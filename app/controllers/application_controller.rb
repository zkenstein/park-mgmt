class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: "Please sign in first!"
    end
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end

  def current_user_admin?
    current_user && current_user.admin?
  end

  helper_method :current_user_admin?

  def b_status(building)
    vacant = 0
    occupied = 0
    total = 0
    building.floors.each do |flr|
      flr.ccunits.each do |ccu|
        ccu.zcunits.each do |zcu|
          vacant += zcu.lots.where(status: "vacant").count
          occupied += zcu.lots.where(status: "Occupied").count
        end
      end
    end
    total = vacant + occupied
    status = {:vacant_b => vacant, :occupied_b => occupied, :total_b => total, :bid => building.id}
    return status
  end

  helper_method :b_status

  def f_status(floor)
    vacant = 0
    occupied = 0
    total = 0
    floor.ccunits.each do |ccu|
      ccu.zcunits.each do |zcu|
        vacant += zcu.lots.where(status: "vacant").count
        occupied += zcu.lots.where(status: "Occupied").count
      end
    end
    total = vacant + occupied
    status = {:vacant => vacant, :occupied => occupied, :total => total, :fid => floor.id, :bid => floor.building.id}
    return status
  end

  helper_method :f_status

  def l_status(zcunit)
    a = ""
    zcunit.lots.each do |lot|
      if (lot.status == "vacant")
        a.concat("0")
      else
        a.concat("1")
      end
    end
    status = {:zcid => zcunit.zcid, :lstatus => a, :fname => zcunit.ccunit.floor.name, :bname => zcunit.ccunit.floor.building.name}
    return status
  end

  helper_method :l_status
 
end 

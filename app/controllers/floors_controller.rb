require 'parkmgmt/client'

class FloorsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :set_floor, only: [:show, :edit, :update, :destroy]
 
  def book
    slot = params[:slot]
    status = params[:status]
    sval = slot.split("\-")
    b = sval[1]
    f = sval[2]
    z1 = sval[3]
    l = sval[4]
    
    @building = Building.find_by_id(b)
    ccu = @building.floors.find_by_id(f).ccunits.first 
    zcu = ccu.zcunits.find_by_zcid(z1)
    lot = zcu.lots.find_by_lotid(l)
    lot.status = status
    lot.save

    ParkCmd::Client.host = '192.168.16.254'
    ParkCmd::Client.port = 3073
    #ParkCmd::Client.set '2112'
    ParkCmd::Client.set status

  render nothing: true
  end

  # GET /floors
  # GET /floors.json
  def index
    @floors = Floor.all
    @buildings = Building.all
  end

  # GET /floors/1
  # GET /floors/1.json
  def show
  end

  # GET /floors/new
  def new
    @floor = Floor.new
    @buildings = Building.all
  end

  # GET /floors/1/edit
  def edit
    @buildings = Building.all
    puts params.inspect
  end
 
  # POST /floors
  # POST /floors.json
  def create
    @floor = Floor.new(floor_params)

    respond_to do |format|
      if @floor.save
        format.html { redirect_to @floor, notice: 'Floor was successfully created.' }
        format.json { render :show, status: :created, location: @floor }
      else
        format.html { render :new }
        format.json { render json: @floor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /floors/1
  # PATCH/PUT /floors/1.json
  def update
    respond_to do |format|
      if @floor.update(floor_params)
        format.html { redirect_to @floor, notice: 'Floor was successfully updated.' }
        format.json { render :show, status: :ok, location: @floor }
      else
        format.html { render :edit }
        format.json { render json: @floor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /floors/1
  # DELETE /floors/1.json
  def destroy
    @floor.destroy
    respond_to do |format|
      format.html { redirect_to floors_url, notice: 'Floor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_floor
      @floor = Floor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def floor_params
      params.require(:floor).permit(:name, :image_url, :building_id)
    end

end

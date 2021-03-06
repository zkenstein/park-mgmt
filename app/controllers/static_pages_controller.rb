require 'reloader/sse'

class StaticPagesController < ApplicationController
  include ActionController::Live
  
  def park_stream
    response.headers['Content-Type'] = 'text/event-stream'

    sse = Reloader::SSE.new(response.stream)
    last_updated = Lot.last_updated.first

    if recently_changed? last_updated
      begin
        ccunit = last_updated.zcunit.ccunit
        floor = ccunit.floor
        building = floor.building
        a = ccunit.zcunits.pluck(:zcid)
        floor_status = Floor.f_status(floor)
        building_status = Building.b_status(building)

        for i in 0..a.size-1
          zcu = ccunit.zcunits.find_by_zcid(a[i])
          if i == 0
            offset = 0
          else
            i -= 1
            zcu1 = ccunit.zcunits.find_by_zcid(a[i])
            offset += zcu1.lots.count
          end
          lot_status = Zcunit.l_status(zcu, offset)
          sse.write(lot_status, event: 'results')
        end

        sse.write(floor_status, event: 'results')
        sse.write(building_status, event: 'results')
      rescue ClientDisconnected
        # rescue IOError 
        # When the client disconnects, we'll get an IOError on write
        logger.info "Stream closed"
      ensure
        logger.info "Stopping stream thread"
        sse.close
      end
    end
      render nothing: true
  end


  def home
  end


private

  def recently_changed? last_event
    last_event.created_at > 5.seconds.ago or
      last_event.updated_at > 5.seconds.ago
  end

end

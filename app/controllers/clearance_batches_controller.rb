class ClearanceBatchesController < ApplicationController
  def index
    @clearance_batches = ClearanceBatch.all

    if params[:id].present?
      clearance_batch = ClearanceBatch.find_by(id: params[:id])
      clearance_export_data = ClearancingService.new.export_csv!(clearance_batch)
      filename = "clearance-batch-#{clearance_batch.id}-#{Time.zone.now.to_i}.csv"
    end

    respond_to do |format|
      format.html
      format.csv { send_data clearance_export_data, filename: filename }
    end
  end

  def create
    clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end
end

class SnapshotsController < ApplicationController
  before_action :set_snapshot, only: [:show, :edit, :update, :destroy]

  # GET /snapshots
  # GET /snapshots.json
  def index
    @snapshots = Snapshot.all
  end

  # GET /snapshots/1
  # GET /snapshots/1.json
  def show
  end

  # GET /snapshots/new
  def new
    @snapshot = Snapshot.new
  end

  # GET /snapshots/1/edit
  def edit
  end

  # POST /snapshots
  # POST /snapshots.json
  def create
    respond_to do |format|
      if Snapshot.create_tracker new_snapshot_params
        format.html { redirect_to snapshots_path, notice: 'Snapshot was successfully created.' }
        format.json { render json: { status: :ok } }
      else
        format.html { render :new }
        format.json { render json: { status: :failed } }
      end
    end
  end

  # PATCH/PUT /snapshots/1
  # PATCH/PUT /snapshots/1.json
  def update
    respond_to do |format|
      if @snapshot.update(snapshot_params)
        format.html { redirect_to @snapshot, notice: 'Snapshot was successfully updated.' }
        format.json { render :show, status: :ok, location: @snapshot }
      else
        format.html { render :edit }
        format.json { render json: @snapshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snapshots/1
  # DELETE /snapshots/1.json
  def destroy
    @snapshot.destroy
    respond_to do |format|
      format.html { redirect_to snapshots_url, notice: 'Snapshot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /snapshots/api_spec
  # GET /snapshots/api_spec.json
  def api_spec
    snapshot = Snapshot.find_by(project_id: params[:project_id].to_i,
                                data_name: 'activities',
                                origin: 'pivotal_tracker')
    if snapshot.nil?
      render json: { ready: false }
    else
      render json: { ready: true }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_snapshot
    @snapshot = Snapshot.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def snapshot_params
    params.require(:snapshot).permit(:origin, :data_name, :query, :content, :headers, :taken_at)
  end

  def new_snapshot_params
    params.require(:snapshot).permit(:tracker_project, :tracker_token)
  end

end

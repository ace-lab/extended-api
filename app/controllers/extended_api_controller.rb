class ExtendedApiController < ApplicationController

  # Extended API for /projects/#{project_id}/stories
  def stories
    pid = params[:pid]
    at_time = Time.at(params.fetch(:at_time, Time.now.to_i.to_s).to_i)
    stories = Snapshot.replay_stories_at(pid, at_time)
    render json: stories
  end
end

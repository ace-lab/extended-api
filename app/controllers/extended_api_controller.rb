class ExtendedApiController < ApplicationController

  # Extended API for /projects/#{project_id}/stories
  def stories
    pid = params[:pid]
    at_time = Time.at(params.fetch(:at_time, Time.now.to_i.to_s).to_i)
    stories = Snapshot.replay_stories_at(pid, at_time)
    render json: stories
  end

  # Extended API for /projects/:pid/stories/:sid/transitions
  def story_transitions
    snapshot = Snapshot.find_by(query: "projects/#{params[:pid]}/activity")
    transitions = snapshot.story_transitions(params[:sid].to_i)
    render json: transitions
  end
end

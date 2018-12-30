module ServiceConfig
  def tracker_config
    JSON.parse(file_fixture('tracker_config.json').read, symbolize_names: true)
  end
end
json.extract! snapshot, :id, :origin, :data_name, :query, :content, :headers, :taken_at, :created_at, :updated_at
json.url snapshot_url(snapshot, format: :json)

require 'sinatra'
require 'json'

$pass = 0

get '/capistrano/participating' do
  $pass = $pass + 1
  {participating: true}.to_json
end

post '/capistrano/sign-up' do
  if $pass % 2 == 0
    return [422, {}, {reason: 'invalid', errors: {email: ['not_unique']}}.to_json]
  end
  request.body.rewind
  data = JSON.parse(request.body.read, symbolize_names: true)
  url = data.fetch(:repository_url, '')

  parts = url[%r{[:/]([^/]*/.*)$}, 1].to_s
  organization, project = parts.split("/")
  project.gsub!(/.git$/, '')

  {
    session_uuid: "94b07854-91ea-4c96-b896-f1d79a4f07aa",
    organization_uuid: "574f01af-1031-41de-8d4f-b4d905ba0c13",
    project_uuid: "4e48b8ec-188a-44c9-be83-999d0737a8d5",
    project_name: project,
    organization_name: organization,
  }.to_json
end

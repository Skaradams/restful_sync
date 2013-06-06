namespace :restful_sync do
  desc "Add API targets and authentication tokens"
  task add_sources: :environment do
    targets = ENV['targets'].split(',') rescue []
    tokens = ENV['tokens'].split(',') rescue []
    
    targets.each do |target|
      RestfulSync::ApiTarget.create end_point: target
    end

    tokens.each do |token|
      RestfulSync::ApiClient.create authentication_token: token
    end
  end
end
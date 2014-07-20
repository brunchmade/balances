require 'tasks/helpers/rake_logger'

namespace :users do

  task update_email_hashes: :environment do
    RakeLogger.log "=== Updating User Email Hashes ==="

    User.find_each do |user|
      RakeLogger.log "Updating user: #{user.id}"
      user.email_hash = user.generate_email_hash
      user.save
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end

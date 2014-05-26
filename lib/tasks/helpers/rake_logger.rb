class RakeLogger

  def self.log (message)
    @start_time = Time.now unless @start_time
    @last_logged_time = Time.now unless @last_logged_time
    timestamp = Time.at(Time.now - @start_time).utc.strftime('%H:%M:%S:%L')
    time_since = Time.at(Time.now - @last_logged_time).utc.strftime('%S:%L')
    puts "#{timestamp} - #{time_since}s - #{message}"
    @last_logged_time = Time.now
  end

end

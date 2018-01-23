class DeltaLogger
  def initialize app
    @app = app
  end

  def call env
    request_started_on = Time.current
    @status, @headers, @response = @app.call(env)
    request_ended_on = Time.current
    Rails.logger.debug "=" * 50
    Rails.logger.debug "Request delta time: #{ request_ended_on - request_started_on } seconds"
    Rails.logger.debug "=" * 50
    [@status, @headers, @response]
  end
end

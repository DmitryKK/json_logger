module JsonLogger
  class Formatter < Logger::Formatter
    def call(severity, timestamp, progname, message)
      default_hash = { type: severity, time: timestamp }

      default_hash.merge!(user_id: user.id) if user.respond_to?(:id)
      default_hash.merge!(url: request.original_url, params: request.path_parameters) if request.respond_to?(:original_url) && request.respond_to?(:path_parameters)

      case message
      when Hash
        default_hash.merge(message)
      when String
        default_hash.merge(message: message)
      when Exception
        default_hash.merge(kind: :exception,
                           message: message.message,
                           class: message.class.name,
                           backtrace: message.backtrace || [])
      else
        default_hash.merge(message: message.inspect)
      end.to_json + "\n"
    end

    private

    def request
      Thread.current[:request]
    end

    def user
      Thread.current[:user]
    end
  end
end

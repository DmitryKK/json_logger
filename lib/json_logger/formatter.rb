module JsonLogger
  class Formatter < Logger::Formatter
    def call(severity, timestamp, progname, message)
      default_hash = {
        type: severity,
        time: timestamp,
        user_id: Thread.current[:user].try(:id)
      }

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
  end
end
require "json"

module JsonLogger
  class SidekiqFormatter < Logger::Formatter
    def call(severity, timestamp, progname, message)
      default_hash = {
        type: severity,
        time: timestamp
      }

      default_hash.merge!(worker: worker) if worker

      case message
      when Hash
        default_hash.merge(message)
      when String
        default_hash.merge(message: message)
      when Exception
        default_hash.merge(message: message.message,
                            backtrace: message.backtrace || [])
      else
        default_hash.merge(message: message.inspect)
      end.to_json + "\n"

    end

    def worker
      "#{context}".split(" ")[0]
    end
  end
end

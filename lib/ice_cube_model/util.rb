module IceCubeModel
  module Util
    def self.sanitize_date_param(date)
      date = date.to_time(:utc) if date.is_a?(::Date) && !date.is_a?(::DateTime)
      date = date.to_time.utc if date.is_a?(::DateTime)
      date = Time.at(date).utc if date.is_a?(::Integer)

      date
    end
  end
end

module IceCubeModel
  module Util
    def self.build_schedule(params)
      schedule = ::IceCube::Schedule.new(::IceCubeModel::Util.sanitize_date_param(params[:repeat_start_date]))
      schedule.add_recurrence_rule ::IceCubeModel::Util.build_cyclical_repeat_rules(params)

      schedule
    end

    def self.build_cyclical_repeat_rules(params)
      rule = ::IceCubeModel::Util.build_root_recurrence_rule(params)

      rule = rule.month_of_year(*params[:repeat_month]) unless params[:repeat_month].blank?
      rule = rule.day_of_month(*params[:repeat_day]) unless params[:repeat_day].blank?
      rule = rule.day(*params[:repeat_weekday]) unless params[:repeat_weekday].blank?

      rule
    end

    def self.build_root_recurrence_rule(params)
      interval = params[:repeat_interval]
      return ::IceCube::Rule.yearly(interval) unless params[:repeat_month].blank?
      return ::IceCube::Rule.weekly(interval) unless params[:repeat_weekday].blank?

      ::IceCube::Rule.monthly(interval)
    end

    def self.sanitize_date_param(date)
      date = date.to_time(:utc) if date.is_a?(::Date) && !date.is_a?(::DateTime)
      date = date.to_time.utc if date.is_a?(::DateTime)
      date = Time.at(date).utc if date.is_a?(::Integer)

      date
    end

    def self.sanitize_integer_array_param(param)
      return nil if param.blank?
      return param if param.is_a?(::Array)
      return [param] if param.is_a?(::Integer)

      param.split(',').map(&:to_i)
    end

    def self.sanitize_integer_param(param)
      return 1 if param.blank?

      param.to_i
    end
  end
end

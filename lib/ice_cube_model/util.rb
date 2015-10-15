module IceCubeModel
  module Util
    def self.build_schedule(params)
      schedule = ::IceCube::Schedule.new(sanitize_date_param(params[:repeat_start_date]))
      schedule.add_recurrence_rule build_repeat_rules(params)

      schedule
    end

    def self.build_repeat_rules(params)
      rule = build_root_recurrence_rule(params)
      rule = rule.month_of_year(*params[:repeat_month]) unless params[:repeat_month].blank?
      rule = rule.day_of_month(*params[:repeat_day]) unless params[:repeat_day].blank?
      rule = build_weekday_rule(rule, params)

      rule
    end

    def self.build_weekday_rule(rule, params)
      return rule.day_of_week(*params[:repeat_weekday]) if !params[:repeat_weekday].blank? && nth_day?(params[:repeat_weekday])
      return rule.day(*params[:repeat_weekday]) unless params[:repeat_weekday].blank?

      rule
    end

    def self.build_root_recurrence_rule(params)
      interval = params[:repeat_interval]
      return ::IceCube::Rule.yearly(interval) unless params[:repeat_month].blank?
      return ::IceCube::Rule.monthly(interval) if !params[:repeat_weekday].blank? && nth_day?(params[:repeat_weekday])
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

    def self.sanitize_week_day_param(param)
      param.to_s.split(',').map do |element|
        if element =~ /[0-9]+#[0-9]+/
          parts = element.split('#')
          { sanitize_integer_param(parts[0]) => sanitize_integer_array_param(parts[1]) }
        elsif element =~ /[0-9]+L/
          { sanitize_integer_param(element) => [-1] }
        else
          sanitize_integer_param(element)
        end
      end
    end

    def self.sanitize_integer_param(param)
      return 1 if param.blank?

      param.to_i
    end

    def self.nth_day?(param)
      return false if param.nil? || param.empty?
      param[0].is_a?(::Hash)
    end
  end
end

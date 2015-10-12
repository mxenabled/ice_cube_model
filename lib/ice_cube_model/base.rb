module IceCubeModel
  module Base
    def self.extend(base)
      base.extend(::IceCubeModel::Base::ClassMethods)
    end

    def events_between(start, through)
      params = read_cyclical_params
      schedule = ::IceCubeModel::Util.build_schedule(params)
      schedule.occurrences_between(::IceCubeModel::Util.sanitize_date_param(start), (::IceCubeModel::Util.sanitize_date_param(through))).map(&:to_date)
    end

  private

    def read_cyclical_params
      {
        :start_date => start_date,
        :repeat_interval => ::IceCubeModel::Util.sanitize_integer_param(repeat_interval),
        :repeat_year => ::IceCubeModel::Util.sanitize_integer_array_param(repeat_year),
        :repeat_month => ::IceCubeModel::Util.sanitize_integer_array_param(repeat_month),
        :repeat_day => ::IceCubeModel::Util.sanitize_integer_array_param(repeat_day),
        :repeat_weekday => ::IceCubeModel::Util.sanitize_integer_array_param(repeat_weekday)
      }
    end

    module ClassMethods
    end
  end
end

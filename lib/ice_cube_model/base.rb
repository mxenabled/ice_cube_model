module IceCubeModel
  module Base
    def self.included(base)
      base.extend(::IceCubeModel::Base::ClassMethods)
    end

    def events_between(start, through)
      params = read_repeat_params
      schedule = ::IceCube::Schedule.from_cron(read_repeat_parameter(:repeat_start_date), params)

      schedule.occurrences_between(::IceCubeModel::Util.sanitize_date_param(start), ::IceCubeModel::Util.sanitize_date_param(through))
    end
    alias_method :occurrences_between, :events_between

  private

    def read_repeat_parameter(param_name)
      send(self.class.repeat_parameter_mappings[param_name])
    end

    def read_repeat_params
      {
        :repeat_interval => read_repeat_parameter(:repeat_interval),
        :repeat_year => read_repeat_parameter(:repeat_year),
        :repeat_month => read_repeat_parameter(:repeat_month),
        :repeat_day => read_repeat_parameter(:repeat_day),
        :repeat_weekday => read_repeat_parameter(:repeat_weekday)
      }
    end

    module ClassMethods
      def repeat_parameter_mappings
        mappings_name = :@@repeat_parameter_mappings

        unless class_variable_defined?(mappings_name)
          class_variable_set(mappings_name,             :repeat_start_date => :repeat_start_date,
                                                        :repeat_interval   => :repeat_interval,
                                                        :repeat_year       => :repeat_year,
                                                        :repeat_month      => :repeat_month,
                                                        :repeat_day        => :repeat_day,
                                                        :repeat_weekday    => :repeat_weekday)
        end

        class_variable_get(mappings_name)
      end

      def with_repeat_param(param_name, replacement)
        repeat_parameter_mappings[param_name] = method_name = "repeat #{param_name}"
        if replacement.is_a?(::Proc)
          define_method(method_name) do
            replacement.call
          end
        else
          define_method(method_name) do
            send(replacement)
          end
        end
      end
    end
  end
end

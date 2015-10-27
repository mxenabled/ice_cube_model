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

    def respond_to?(name, include_private = false)
      return true if self.class.repeat_parameter_mappings.values.include?(name.to_sym)
      super
    end

  private

    def read_repeat_parameter(param_name)
      param_method = self.class.repeat_parameter_mappings[param_name.to_sym] || param_name.to_sym
      return nil unless respond_to?(param_method)

      send(param_method)
    end

    def read_repeat_params
      {
        :repeat_interval => read_repeat_parameter(:repeat_interval),
        :repeat_year => read_repeat_parameter(:repeat_year),
        :repeat_month => read_repeat_parameter(:repeat_month),
        :repeat_day => read_repeat_parameter(:repeat_day),
        :repeat_weekday => read_repeat_parameter(:repeat_weekday),
        :repeat_until => read_repeat_parameter(:repeat_until)
      }
    end

    module ClassMethods
      def repeat_parameter_mappings
        @repeat_parameter_mappings ||= begin
          if superclass.respond_to?(:repeat_parameter_mappings)
            superclass.repeat_parameter_mappings.dup
          else
            {}
          end
        end
      end

      def with_repeat_param(param_name, replacement)
        repeat_parameter_mappings[param_name] = param_sym = "ice_cube_model #{param_name}".to_sym
        if replacement.is_a?(::Proc)
          define_method(param_sym) do
            replacement.call
          end
        else
          define_method(param_sym) do
            send(replacement)
          end
        end
      end
    end
  end
end

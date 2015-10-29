module IceCubeModel
  module Base
    def self.included(base)
      base.extend(::IceCubeModel::Base::ClassMethods)
    end

    def schedule
      ::IceCube::Schedule.from_cron(read_repeat_parameter(:repeat_start_date), read_repeat_params)
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
        :repeat_day_of_month => read_repeat_parameter(:repeat_day_of_month),
        :repeat_day_of_week => read_repeat_parameter(:repeat_day_of_week),
        :repeat_hour => read_repeat_parameter(:repeat_hour),
        :repeat_minute => read_repeat_parameter(:repeat_minute),
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

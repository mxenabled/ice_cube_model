module IceCubeModel
  module Base
    DELEGATED_METHODS = [
      :occurrences,
      :all_occurrences,
      :all_occurrences_enumerator,
      :next_occurrences,
      :next_occurrence,
      :previous_occurrences,
      :previous_occurrence,
      :remaining_occurrences,
      :remaining_occurrences_enumerator,
      :occurrences_between,
      :occurs_between?,
      :occurring_between?,
      :occurs_on?,
      :first,
      :last
    ]

    def self.included(base)
      base.extend(::IceCubeModel::Base::ClassMethods)
    end

    def schedule
      ::IceCube::Schedule.from_cron(read_repeat_parameter(:repeat_start_date), read_repeat_params)
    end

    def respond_to?(name, include_private = false)
      ## Does respond to delegated methods. method_missing will lazy define them as they are used.
      return true if DELEGATED_METHODS.include?(name.to_sym)
      return true if self.class.repeat_parameter_mappings.values.include?(name.to_sym)
      super
    end

    # TODO: For backward compatibility. Remove before prod ready release.
    delegate :occurrences_between, :to => :schedule
    alias_method :events_between, :occurrences_between

    ##
    # Implementing method_missing as a *lazy* delegator. Doing this to prevent overwriting
    # target class' methods.
    #
    def method_missing(name, *args, &block)
      if DELEGATED_METHODS.include?(name.to_sym)
        self.class.send(:define_method, name.to_sym) do |*method_args|
          schedule.send(name, *method_args, &block)
        end
        send(name, *args)
      else
        super
      end
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

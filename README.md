# ice_cube_model
Extend any object with [ice_cube](https://github.com/seejohnrun/ice_cube) (calendar repeating event) capabilities.

Add ice_cube methods to classes (e.g. active_record, active_model).

## installation

    gem install ice_cube_model

or add to Gemfile

    gem "ice_cube_model"


## example

```ruby
class Appointment
    attr_accessor 
        :repeat_start_date,
        :repeat_interval,
        :repeat_year,
        :repeat_month,
        :repeat_day,
        :repeat_weekday

    include ::IceCubeModel::Base
end

appointment = Appointment.new
appointment.repeat_start_date = ::Date.new(2015, 3, 5)
appointment.repeat_day = 5

appointment.occurrences_between(::Date.new(2015, 3, 5), ::Date.new(2015, 6, 5))
# => [2015-03-05, 2015-04-05, 2015-06-05]
```

## remap attributes

If needed, you can remap the attributes expected by ice_cube to other attributes or methods on the class.

```ruby

# map to another attribute
class Appointment
    attr_accessor 
        :start_date,
        :repeat_interval,
        :repeat_year,
        :repeat_month,
        :repeat_day,
        :repeat_weekday

    include ::IceCubeModel::Base

    with_repeat_param :repeat_start_date, :start_date
end

# map to a method
class Appointment
    attr_accessor 
        :repeat_interval,
        :repeat_year,
        :repeat_month,
        :repeat_day,
        :repeat_weekday

    include ::IceCubeModel::Base

    with_repeat_param :repeat_start_date, :calculate_start_date

    def calculate_start_date
        Date.current + 7.days
    end
end

# map to a lambda
class Appointment
    attr_accessor 
        :repeat_interval,
        :repeat_year,
        :repeat_month,
        :repeat_day,
        :repeat_weekday

    include ::IceCubeModel::Base

    with_repeat_param :repeat_start_date, lambda { Date.current + 7.days }
end
```

## NOTES:
- This gem is a work-in-progress.
- `occurrences_between` is the only method currently supported.
- Does not yet support all recurrence options. More coming.

## ToDo:
- Add more examples to specs and README
- Add ability to do Nth types of repeats (e.g. last friday of the month, first and third tuesday of every month). These are supported by ice_cube.


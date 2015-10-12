# ice_cube_model
Extend any object with [ice_cube](https://github.com/seejohnrun/ice_cube) (calendar repeating event) capabilities.

Add ice_cube methods to classes (e.g. active_record, active_model).

## example

```ruby
class Appointment
    attr_accessor 
        :start_date,
        :repeat_interval,
        :repeat_year,
        :repeat_month,
        :repeat_day,
        :repeat_weekday

    include ::IceCubeModel
end

appointment = Appointment.new
appointment.start_date = ::Date.new(2015, 3, 5)
appointment.repeat_day = 5

appointment.occurrences_between(::Date.new(2015, 3, 5), ::Date.new(2015, 6, 5))
# => [2015-03-05, 2015-04-05, 2015-06-05]
```

## installation

    gem install ice_cube_model

or add to Gemfile

    gem "ice_cube_model"


## NOTES:
- This gem is a work-in-progress.
- Only supported method right now is `occurrences_between`.
- Does not yet support all recurrence options. More coming.


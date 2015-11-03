[![Gem Version](https://badge.fury.io/rb/ice_cube_model.svg)](https://badge.fury.io/rb/ice_cube_model) [![Build Status](https://travis-ci.org/mattnichols/ice_cube_model.svg?branch=master)](https://travis-ci.org/mattnichols/ice_cube_model)

# ice_cube_model

Extend any "cron-expression" object with [ice_cube](https://github.com/seejohnrun/ice_cube) (calendar repeating event) capabilities.

Add ice_cube methods to a class (e.g. active_record, active_model) that has cron expression fields.

## description

**ice_cube** is a sold library for projecting and querying recurrence rules. **Cron** is _the_ standard for expressing recurrence rules. If you have a model that stores cron fields in separate attributes, then this gem will allow you to map those attributes into ice_cube and execute projection and queries against it.

The fields in the model can use standard cron expression syntax [explained here](https://en.wikipedia.org/wiki/Cron). This includes range expressions, series expressions, "last" day of month, Nth weekday of month, etc.

PLEASE NOTE:
This gem is a work-in-progress. Many features have yet to be implemented.

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

## recurrence rule examples (date)

|desc|interval|year|month|day|weekday|
|----|-------:|---:|----:|--:|------:|
|1st of every month||||1||
|1st and 15th of every month||||1,15||
|every monday|||||1|
|1st monday of every month|||||1#1|
|ever other friday|2||||5|
|every 6 months on the 5th|6|||5||
|last friday of every month|||||5L|
|last day every month||||L||

## notes
- This gem is a work-in-progress.
- Does not yet support all recurrence options. More coming.
- Supports inheritance but will not pick up dynamic changes in parent class parameter mappings.

## todo
- Allow mapping of a single cron expression (string) field, rather than individual fields.


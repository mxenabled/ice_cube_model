module IceCubeModel
  module Delegator
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

    def self.included(_base)
      DELEGATED_METHODS.each do |name|
        delegate name, :to => :schedule
      end
    end
  end
end

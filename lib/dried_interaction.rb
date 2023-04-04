# frozen_string_literal: true

require 'dry/matcher'
require 'dry/matcher/result_matcher'
require 'dry/monads'
require 'dry-initializer'

require 'dried_interaction/class_methods'
require 'dried_interaction/instance_methods'

module DriedInteraction
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.extend(Dry::Initializer)

    klass.prepend(InstanceMethods)
    klass.include(Dry::Monads[:result, :do])
    klass.include(Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher))
  end
end

module Ftpmock
  module MethodMissingMixin
    def method_missing(name, *_args)
      msg = "  Missing method `#{self.class.name}##{name}`. Ignoring"
      configuration.verbose && VerboseUtils.warn(msg)
      nil
    end
  end
end

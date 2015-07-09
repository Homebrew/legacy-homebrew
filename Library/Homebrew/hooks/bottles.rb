# Boxen (and perhaps others) want to override our bottling infrastructure so
# they can avoid declaring checksums in formulae files.
# Instead of periodically breaking their monkeypatches let's add some hooks that
# we can query to allow their own behaviour.

# PLEASE DO NOT EVER RENAME THIS CLASS OR ADD/REMOVE METHOD ARGUMENTS!
module Homebrew
  module Hooks
    module Bottles
      def self.setup_formula_has_bottle(&block)
        @has_bottle = block
        true
      end

      def self.setup_pour_formula_bottle(&block)
        @pour_bottle = block
        true
      end

      def self.formula_has_bottle?(formula)
        return false unless @has_bottle
        @has_bottle.call formula
      end

      def self.pour_formula_bottle(formula)
        return false unless @pour_bottle
        @pour_bottle.call formula
      end

      def self.reset_hooks
        @has_bottle = @pour_bottle = nil
      end
    end
  end
end

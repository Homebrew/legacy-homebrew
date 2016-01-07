module Homebrew
  module Diagnostic
    class Checks
      def check_integration_test
        "This is an integration test" if ENV["HOMEBREW_INTEGRATION_TEST"]
      end
    end
  end
end

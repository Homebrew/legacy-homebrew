require "extend/ENV"
require "timeout"

module Homebrew
  TEST_TIMEOUT_SECONDS = 5*60

  if defined?(Gem)
    begin
      gem "minitest", "< 5.0.0"
    rescue Gem::LoadError
      require "test/unit/assertions"
      FailedAssertion = Test::Unit::AssertionFailedError
    else
      require "minitest/unit"
      require "test/unit/assertions"
      FailedAssertion = MiniTest::Assertion
    end
  else
    require "test/unit/assertions"
    FailedAssertion = Test::Unit::AssertionFailedError
  end

  def test
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ENV.extend(Stdenv)
    ENV.setup_build_environment

    ARGV.formulae.each do |f|
      # Cannot test uninstalled formulae
      unless f.installed?
        ofail "Testing requires the latest version of #{f.name}"
        next
      end

      # Cannot test formulae without a test method
      unless f.test_defined?
        ofail "#{f.name} defines no test"
        next
      end

      puts "Testing #{f.name}"

      f.extend(Test::Unit::Assertions)

      begin
        # tests can also return false to indicate failure
        Timeout::timeout TEST_TIMEOUT_SECONDS do
          raise if f.test == false
        end
      rescue FailedAssertion => e
        ofail "#{f.name}: failed"
        puts e.message
      rescue Exception => e
        ofail "#{f.name}: failed"
        puts e, e.backtrace
      end
    end
  end
end

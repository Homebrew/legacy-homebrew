require 'extend/ENV'
require 'hardware'
require 'keg'
require 'timeout'
require 'test/unit/assertions'

module Homebrew extend self
  TEST_TIMEOUT_SECONDS = 5*60

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
      begin
        # tests can also return false to indicate failure
        Timeout::timeout TEST_TIMEOUT_SECONDS do
          raise if f.test == false
        end
      rescue Test::Unit::AssertionFailedError => e
        ofail "#{f.name}: failed"
        puts e.message
      rescue Exception
        ofail "#{f.name}: failed"
      end
    end
  end
end

require 'extend/ENV'
require 'hardware'
require 'keg'

ENV.extend(HomebrewEnvExtension)
ENV.setup_build_environment

module Homebrew extend self
  def test
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      # Cannot test uninstalled formulae
      unless f.installed?
        ofail "Testing requires the latest version of #{f.name}"
        next
      end

      # Cannot test formulae without a test method
      unless f.respond_to? :test
        ofail "#{f.name} defines no test"
        next
      end

      puts "Testing #{f.name}"
      begin
        # tests can also return false to indicate failure
        raise if f.test == false
      rescue
        ofail "#{f.name}: failed"
      end
    end
  end
end

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
        puts "Testing requires the latest version of #{f.name}"
        Homebrew.failed = true
        next
      end

      # Cannot test formulae without a test method
      unless f.respond_to? :test
        puts "#{f.name} defines no test"
        Homebrew.failed = true
        next
      end

      puts "Testing #{f.name}"
      begin
        # tests can also return false to indicate failure
        raise if f.test == false
      rescue
        puts "#{f.name}: failed"
        Homebrew.failed = true
      end
    end
  end
end

require "extend/ENV"
require "formula_assertions"
require "sandbox"
require "timeout"

module Homebrew

  def test
    raise FormulaUnspecifiedError if ARGV.named.empty?

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

      env = ENV.to_hash

      begin
        args = %W[
          #{RUBY_PATH}
          -W0
          -I #{HOMEBREW_LIBRARY_PATH}
          --
          #{HOMEBREW_LIBRARY_PATH}/test.rb
          #{f.path}
        ].concat(ARGV.options_only)

        Utils.safe_fork do
          if Sandbox.available? && ARGV.sandbox?
            sandbox = Sandbox.new
            logd = HOMEBREW_LOGS/f.name
            logd.mkpath
            sandbox.record_log(logd/"sandbox.test.log")
            sandbox.allow_write_temp_and_cache
            sandbox.allow_write_log(f)
            sandbox.exec(*args)
          else
            exec(*args)
          end
        end
      rescue Assertions::FailedAssertion => e
        ofail "#{f.name}: failed"
        puts e.message
      rescue Exception => e
        ofail "#{f.name}: failed"
        puts e, e.backtrace
      ensure
        ENV.replace(env)
      end
    end
  end
end

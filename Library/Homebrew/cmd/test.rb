require "extend/ENV"
require "formula_assertions"
require "sandbox"
require "timeout"

module Homebrew
  def test
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.resolved_formulae.each do |f|
      # Cannot test uninstalled formulae
      unless f.installed?
        ofail "Testing requires the latest version of #{f.full_name}"
        next
      end

      # Cannot test formulae without a test method
      unless f.test_defined?
        ofail "#{f.full_name} defines no test"
        next
      end

      puts "Testing #{f.full_name}"

      env = ENV.to_hash

      begin
        args = %W[
          #{RUBY_PATH}
          -W0
          -I #{HOMEBREW_LOAD_PATH}
          --
          #{HOMEBREW_LIBRARY_PATH}/test.rb
          #{f.path}
        ].concat(ARGV.options_only)

        if Sandbox.available? && ARGV.sandbox?
          if Sandbox.auto_disable?
            Sandbox.print_autodisable_warning
          else
            Sandbox.print_sandbox_message
          end
        end

        Utils.safe_fork do
          if Sandbox.available? && ARGV.sandbox? && !Sandbox.auto_disable?
            sandbox = Sandbox.new
            f.logs.mkpath
            sandbox.record_log(f.logs/"sandbox.test.log")
            sandbox.allow_write_temp_and_cache
            sandbox.allow_write_log(f)
            sandbox.allow_write_xcode
            sandbox.exec(*args)
          else
            exec(*args)
          end
        end
      rescue Assertions::FailedAssertion => e
        ofail "#{f.full_name}: failed"
        puts e.message
      rescue Exception => e
        ofail "#{f.full_name}: failed"
        puts e, e.backtrace
      ensure
        ENV.replace(env)
      end
    end
  end
end

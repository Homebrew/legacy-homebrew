require "sandbox"

module Homebrew
  def postinstall
    ARGV.resolved_formulae.each { |f| run_post_install(f) if f.post_install_defined? }
  end

  def run_post_install(formula)
    args = %W[
      nice #{RUBY_PATH}
      -W0
      -I #{HOMEBREW_LOAD_PATH}
      --
      #{HOMEBREW_LIBRARY_PATH}/postinstall.rb
      #{formula.path}
    ].concat(ARGV.options_only)

    if formula.head?
      args << "--HEAD"
    elsif formula.devel?
      args << "--devel"
    end

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
        formula.logs.mkpath
        sandbox.record_log(formula.logs/"sandbox.postinstall.log")
        sandbox.allow_write_temp_and_cache
        sandbox.allow_write_log(formula)
        sandbox.allow_write_cellar(formula)
        sandbox.allow_write_xcode
        sandbox.allow_write_path HOMEBREW_PREFIX
        sandbox.deny_write_homebrew_library
        sandbox.exec(*args)
      else
        exec(*args)
      end
    end
  end
end

require "sandbox"

module Homebrew
  def postinstall
    ARGV.formulae.each { |f| run_post_install(f) }
  end

  def run_post_install(formula)
    args = %W[
      nice #{RUBY_PATH}
      -W0
      -I #{HOMEBREW_LIBRARY_PATH}
      --
      #{HOMEBREW_LIBRARY_PATH}/postinstall.rb
      #{formula.path}
    ].concat(ARGV.options_only)

    Utils.safe_fork do
      if Sandbox.available? && ARGV.sandbox?
        sandbox = Sandbox.new
        logd = HOMEBREW_LOGS/formula.name
        logd.mkpath
        sandbox.record_log(logd/"sandbox.postinstall.log")
        sandbox.allow_write_temp_and_cache
        sandbox.allow_write_log(formula)
        sandbox.allow_write_cellar(formula)
        sandbox.allow_write_path HOMEBREW_PREFIX
        sandbox.deny_write_path HOMEBREW_LIBRARY
        sandbox.deny_write_path HOMEBREW_REPOSITORY/".git"
        sandbox.deny_write HOMEBREW_BREW_FILE
        sandbox.exec(*args)
      else
        exec(*args)
      end
    end
  end
end

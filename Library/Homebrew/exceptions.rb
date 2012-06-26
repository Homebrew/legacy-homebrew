class UsageError < RuntimeError; end
class FormulaUnspecifiedError < UsageError; end
class KegUnspecifiedError < UsageError; end

class MultipleVersionsInstalledError < RuntimeError
  attr :name

  def initialize name
    @name = name
    super "#{name} has multiple installed versions"
  end
end

class NotAKegError < RuntimeError; end

class NoSuchKegError < RuntimeError
  attr :name

  def initialize name
    @name = name
    super "No such keg: #{HOMEBREW_CELLAR}/#{name}"
  end
end

class FormulaUnavailableError < RuntimeError
  attr :name
  attr :dependent, true

  def dependent_s
    "(dependency of #{dependent})" if dependent and dependent != name
  end

  def to_s
    if name =~ %r{(\w+)/(\w+)/([^/]+)} then <<-EOS.undent
      No available formula for #$3 #{dependent_s}
      Please tap it and then try again: brew tap #$1/#$2
      EOS
    else
      "No available formula for #{name} #{dependent_s}"
    end
  end

  def initialize name
    @name = name
  end
end

module Homebrew
  class InstallationError < RuntimeError
    attr :formula

    def initialize formula, message=""
      super message
      @formula = formula
    end
  end
end

class CannotInstallFormulaError < RuntimeError
end

class FormulaInstallationAlreadyAttemptedError < Homebrew::InstallationError
  def message
    "Formula installation already attempted: #{formula}"
  end
end

class UnsatisfiedRequirement < Homebrew::InstallationError
  attr :dep

  def initialize formula, dep
    @dep = dep
    super formula, "An unsatisfied requirement failed this build."
  end
end

class BuildError < Homebrew::InstallationError
  attr :exit_status
  attr :command
  attr :env

  def initialize formula, cmd, args, es
    @command = cmd
    @env = ENV.to_hash
    @exit_status = es.exitstatus rescue 1
    args = args.map{ |arg| arg.to_s.gsub " ", "\\ " }.join(" ")
    super formula, "Failed executing: #{command} #{args}"
  end

  def was_running_configure?
    @command == './configure'
  end

  def dump
    e = self

    require 'cmd/--config'
    require 'cmd/--env'

    e.backtrace[1] =~ %r{Library/Formula/(.+)\.rb:(\d+)}
    formula_name = $1
    error_line = $2

    path = HOMEBREW_REPOSITORY/"Library/Formula/#{formula_name}.rb"
    if path.symlink? and path.realpath.to_s =~ %r{^#{HOMEBREW_REPOSITORY}/Library/Taps/(\w+)-(\w+)/}
      repo = "#$1/homebrew-#$2"
      repo_path = path.realpath.relative_path_from(HOMEBREW_REPOSITORY/"Library/Taps/#$1-#$2").parent.to_s
      issues_url = "https://github.com/#$1/homebrew-#$2/issues/new"
    else
      repo = "mxcl/master"
      repo_path = "Library/Formula"
      issues_url = ISSUES_URL
    end

    if ARGV.verbose?
      ohai "Exit Status: #{e.exit_status}"
      puts "https://github.com/#{repo}/blob/master/#{repo_path}/#{formula_name}.rb#L#{error_line}"
    end
    ohai "Build Environment"
    Homebrew.dump_build_config
    puts %["--use-clang" was specified] if ARGV.include? '--use-clang'
    puts %["--use-llvm" was specified] if ARGV.include? '--use-llvm'
    puts %["--use-gcc" was specified] if ARGV.include? '--use-gcc'
    Homebrew.dump_build_env e.env
    onoe "#{e.to_s.strip} (#{formula_name}.rb:#{error_line})"
    issues = GitHub.issues_for_formula formula_name
    if issues.empty?
      puts "If `brew doctor` does not, this may help you fix or report the issue:"
      puts "    #{Tty.em}#{issues_url}#{Tty.reset}"
    else
      puts "These existing issues may help you:", *issues.map{ |s| "    #{Tty.em}#{s}#{Tty.reset}" }
      puts "Otherwise, this may help you fix or report the issue:"
      puts "    #{Tty.em}#{issues_url}#{Tty.reset}"
    end
    if e.was_running_configure?
      puts "We saved the configure log:"
      puts "    ~/Library/Logs/Homebrew/config.log"
      puts "If you report the issue please paste the config.log here:"
      puts "    #{Tty.em}http://gist.github.com/#{Tty.reset}"
    end
  end
end

# raised in CurlDownloadStrategy.fetch
class CurlDownloadStrategyError < RuntimeError
end

# raised by safe_system in utils.rb
class ErrorDuringExecution < RuntimeError
end

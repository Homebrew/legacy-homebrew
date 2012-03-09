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

  def initialize name
    @name = name
    super "No available formula for #{name}"
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

class UnsatisfiedExternalDependencyError < Homebrew::InstallationError
  attr :type

  def initialize formula, type
    @type = type
    super formula, get_message(formula)
  end

  def get_message formula
    <<-EOS.undent
      Unsatisfied external dependency: #{formula}
      Homebrew does not provide #{type.to_s.capitalize} dependencies, #{tool} does:
        #{command_line} #{formula}
      EOS
  end

  private

  def tool
    case type
      when :python then 'easy_install'
      when :ruby, :jruby, :rbx then 'rubygems'
      when :perl then 'cpan'
      when :node then 'npm'
      when :chicken then 'chicken-install'
      when :lua then "luarocks"
    end
  end

  def command_line
    case type
      when :python
        "easy_install"
      when :ruby
        "gem install"
      when :perl
        "cpan -i"
      when :jruby
        "jruby -S gem install"
      when :rbx
        "rbx gem install"
      when :node
        "npm install"
      when :chicken
        "chicken-install"
      when :lua
        "luarocks install"
    end
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

    ohai "Exit Status: #{e.exit_status}"
    puts "http://github.com/mxcl/homebrew/blob/master/Library/Formula/#{formula_name}.rb#L#{error_line}"
    ohai "Environment"
    puts Homebrew.config_s
    ohai "Build Flags"
    puts %["--use-clang" was specified] if ARGV.include? '--use-clang'
    puts %["--use-llvm" was specified] if ARGV.include? '--use-llvm'
    puts %["--use-gcc" was specified] if ARGV.include? '--use-gcc'
    Homebrew.dump_build_env e.env
    puts
    onoe e
    issues = GitHub.issues_for_formula formula_name
    if issues.empty?
      puts "If `brew doctor' does not help diagnose the issue, please report the bug:"
      puts "    #{Tty.em}#{ISSUES_URL}#{Tty.reset}"
    else
      puts "These existing issues may help you:", *issues.map{ |s| "    #{Tty.em}#{s}#{Tty.reset}" }
      puts "Otherwise, please report the bug:"
      puts "    #{Tty.em}#{ISSUES_URL}#{Tty.reset}"
    end
    if e.was_running_configure?
      puts "We saved the configure log, please gist it if you report the issue:"
      puts "    ~/Library/Logs/Homebrew/config.log"
    end
  end
end

# raised in CurlDownloadStrategy.fetch
class CurlDownloadStrategyError < RuntimeError
end

# raised by safe_system in utils.rb
class ErrorDuringExecution < RuntimeError
end

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

class UnsatisfiedRequirements < Homebrew::InstallationError
  attr :reqs

  def initialize formula, reqs
    @reqs = reqs
    message = (reqs.length == 1) \
                ? "An unsatisfied requirement failed this build." \
                : "Unsatisifed requirements failed this build."
    super formula, message
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
    logs = "#{ENV['HOME']}/Library/Logs/Homebrew/#{formula}/"
    if ARGV.verbose?
      require 'cmd/--config'
      require 'cmd/--env'
      ohai "Configuration"
      Homebrew.dump_build_config
      ohai "ENV"
      Homebrew.dump_build_env(env)
    end
    puts
    onoe "#{formula.name} did not build"
    puts "Logs: #{logs}" unless Dir["#{logs}/*"].empty?
    puts "Help: #{Tty.em}#{ISSUES_URL}#{Tty.reset}"
    issues = GitHub.issues_for_formula(formula.name)
    puts *issues.map{ |s| "      #{Tty.em}#{s}#{Tty.reset}" } unless issues.empty?
  end
end

# raised in CurlDownloadStrategy.fetch
class CurlDownloadStrategyError < RuntimeError
end

# raised by safe_system in utils.rb
class ErrorDuringExecution < RuntimeError
end

# raised by Pathname#verify_checksum when "expected" is nil or empty
class ChecksumMissingError < ArgumentError
end

# raised by Pathname#verify_checksum when verification fails
class ChecksumMismatchError < RuntimeError
  attr :advice, true
  attr :expected
  attr :actual
  attr :hash_type

  def initialize expected, actual
    @expected = expected
    @actual = actual
    @hash_type = expected.hash_type.to_s.upcase

    super <<-EOS.undent
      #{@hash_type} mismatch
      Expected: #{@expected}
      Actual: #{@actual}
      EOS
  end

  def to_s
    super + advice.to_s
  end
end

module Homebrew extend self
  SUDO_BAD_ERRMSG = <<-EOS.undent
    You can use brew with sudo, but only if the brew executable is owned by root.
    However, this is both not recommended and completely unsupported so do so at
    your own risk.
  EOS
end

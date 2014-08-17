class UsageError < RuntimeError; end
class FormulaUnspecifiedError < UsageError; end
class KegUnspecifiedError < UsageError; end

class MultipleVersionsInstalledError < RuntimeError
  attr_reader :name

  def initialize name
    @name = name
    super "#{name} has multiple installed versions"
  end
end

class NotAKegError < RuntimeError; end

class NoSuchKegError < RuntimeError
  attr_reader :name

  def initialize name
    @name = name
    super "No such keg: #{HOMEBREW_CELLAR}/#{name}"
  end
end

class FormulaValidationError < StandardError
  attr_reader :attr

  def initialize(attr, value)
    @attr = attr
    msg = "invalid attribute: #{attr}"
    msg << " (#{value.inspect})" unless value.empty?
    super msg
  end
end

class FormulaSpecificationError < StandardError; end

class FormulaUnavailableError < RuntimeError
  attr_reader :name
  attr_accessor :dependent

  def initialize name
    @name = name
  end

  def dependent_s
    "(dependency of #{dependent})" if dependent and dependent != name
  end

  def to_s
    "No available formula for #{name} #{dependent_s}"
  end
end

class TapFormulaUnavailableError < FormulaUnavailableError
  attr_reader :user, :repo, :shortname

  def initialize name
    super
    @user, @repo, @shortname = name.split("/", 3)
  end

  def to_s; <<-EOS.undent
      No available formula for #{shortname} #{dependent_s}
      Please tap it and then try again: brew tap #{user}/#{repo}
    EOS
  end
end

class OperationInProgressError < RuntimeError
  def initialize name
    message = <<-EOS.undent
      Operation already in progress for #{name}
      Another active Homebrew process is already using #{name}.
      Please wait for it to finish or terminate it to continue.
      EOS

    super message
  end
end

module Homebrew
  class InstallationError < RuntimeError
    attr_reader :formula

    def initialize formula, message=""
      super message
      @formula = formula
    end
  end
end

class CannotInstallFormulaError < RuntimeError; end

class FormulaAlreadyInstalledError < RuntimeError; end

class FormulaInstallationAlreadyAttemptedError < Homebrew::InstallationError
  def message
    "Formula installation already attempted: #{formula}"
  end
end

class UnsatisfiedRequirements < Homebrew::InstallationError
  attr_reader :reqs

  def initialize formula, reqs
    @reqs = reqs
    message = (reqs.length == 1) \
                ? "An unsatisfied requirement failed this build." \
                : "Unsatisifed requirements failed this build."
    super formula, message
  end
end

class IncompatibleCxxStdlibs < Homebrew::InstallationError
  def initialize(f, dep, wrong, right)
    super f, <<-EOS.undent
    #{f} dependency #{dep} was built with a different C++ standard
    library (#{wrong.type_string} from #{wrong.compiler}). This could cause problems at runtime.
    EOS
  end
end

class FormulaConflictError < Homebrew::InstallationError
  attr_reader :f, :conflicts

  def initialize(f, conflicts)
    @f = f
    @conflicts = conflicts
    super f, message
  end

  def conflict_message(conflict)
    message = []
    message << "  #{conflict.name}"
    message << ": because #{conflict.reason}" if conflict.reason
    message.join
  end

  def message
    message = []
    message << "Cannot install #{f.name} because conflicting formulae are installed.\n"
    message.concat conflicts.map { |c| conflict_message(c) } << ""
    message << <<-EOS.undent
      Please `brew unlink #{conflicts.map(&:name)*' '}` before continuing.

      Unlinking removes a formula's symlinks from #{HOMEBREW_PREFIX}. You can
      link the formula again after the install finishes. You can --force this
      install, but the build may fail or cause obscure side-effects in the
      resulting software.
      EOS
    message.join("\n")
  end
end

class BuildError < Homebrew::InstallationError
  attr_reader :command, :env

  def initialize formula, cmd, args
    @command = cmd
    @env = ENV.to_hash
    args = args.map{ |arg| arg.to_s.gsub " ", "\\ " }.join(" ")
    super formula, "Failed executing: #{command} #{args}"
  end

  def issues
    @issues ||= fetch_issues
  end

  def fetch_issues
    GitHub.issues_for_formula(formula.name)
  rescue GitHub::RateLimitExceededError => e
    opoo e.message
    []
  end

  def dump
    if not ARGV.verbose?
      puts
      puts "#{Tty.red}READ THIS#{Tty.reset}: #{Tty.em}#{OS::ISSUES_URL}#{Tty.reset}"
      if formula.tap?
        tap_issues_url = "https://github.com/#{formula.tap}/issues"
        puts "If reporting this issue please do so at (not Homebrew/homebrew):"
        puts "  #{tap_issues_url}"
      end
    else
      require 'cmd/config'
      require 'cmd/--env'

      unless formula.core_formula?
        ohai "Formula"
        puts "Tap: #{formula.tap}"
        puts "Path: #{formula.path}"
      end
      ohai "Configuration"
      Homebrew.dump_build_config
      ohai "ENV"
      Homebrew.dump_build_env(env)
      puts
      onoe "#{formula.name} #{formula.version} did not build"
      unless (logs = Dir["#{HOMEBREW_LOGS}/#{formula}/*"]).empty?
        puts "Logs:"
        puts logs.map{|fn| "     #{fn}"}.join("\n")
      end
    end
    puts
    unless RUBY_VERSION < "1.8.7" || issues.empty?
      puts "These open issues may also help:"
      puts issues.map{ |i| "#{i['title']} (#{i['html_url']})" }.join("\n")
    end
  end
end

# raised by CompilerSelector if the formula fails with all of
# the compilers available on the user's system
class CompilerSelectionError < Homebrew::InstallationError
  def initialize f
    super f, <<-EOS.undent
    #{f.name} cannot be built with any available compilers.
    To install this formula, you may need to:
      brew install gcc
    EOS
  end
end

# Raised in Resource.fetch
class DownloadError < RuntimeError
  def initialize(resource, e)
    super <<-EOS.undent
      Failed to download resource #{resource.download_name.inspect}
      #{e.message}
      EOS
  end
end

# raised in CurlDownloadStrategy.fetch
class CurlDownloadStrategyError < RuntimeError; end

# raised by safe_system in utils.rb
class ErrorDuringExecution < RuntimeError; end

# raised by Pathname#verify_checksum when "expected" is nil or empty
class ChecksumMissingError < ArgumentError; end

# raised by Pathname#verify_checksum when verification fails
class ChecksumMismatchError < RuntimeError
  attr_reader :expected, :hash_type

  def initialize fn, expected, actual
    @expected = expected
    @hash_type = expected.hash_type.to_s.upcase

    super <<-EOS.undent
      #{@hash_type} mismatch
      Expected: #{expected}
      Actual: #{actual}
      Archive: #{fn}
      To retry an incomplete download, remove the file above.
      EOS
  end
end

class ResourceMissingError < ArgumentError
  def initialize formula, resource
    @formula = formula
    @resource = resource
  end

  def to_s
    "Formula #{@formula} does not define resource \"#{@resource}\"."
  end
end

class DuplicateResourceError < ArgumentError
  def initialize resource
    @resource = resource
  end

  def to_s
    "Resource \"#{@resource}\" defined more than once."
  end
end

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

class CannotInstallFormulaError < RuntimeError; end

class FormulaAlreadyInstalledError < RuntimeError; end

class FormulaInstallationAlreadyAttemptedError < RuntimeError
  def initialize(formula)
    super "Formula installation already attempted: #{formula.name}"
  end
end

class UnsatisfiedRequirements < RuntimeError
  def initialize(reqs)
    if reqs.length == 1
      super "An unsatisfied requirement failed this build."
    else
      super "Unsatisified requirements failed this build."
    end
  end
end

class FormulaConflictError < RuntimeError
  attr_reader :formula, :conflicts

  def initialize(formula, conflicts)
    @formula = formula
    @conflicts = conflicts
    super message
  end

  def conflict_message(conflict)
    message = []
    message << "  #{conflict.name}"
    message << ": because #{conflict.reason}" if conflict.reason
    message.join
  end

  def message
    message = []
    message << "Cannot install #{formula.name} because conflicting formulae are installed.\n"
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

class BuildError < RuntimeError
  attr_reader :formula, :env

  def initialize(formula, cmd, args, env)
    @formula = formula
    @env = env
    args = args.map{ |arg| arg.to_s.gsub " ", "\\ " }.join(" ")
    super "Failed executing: #{cmd} #{args}"
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
        puts "If reporting this issue please do so at (not Homebrew/homebrew):"
        puts "  https://github.com/#{formula.tap}/issues"
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
      unless (logs = Dir["#{HOMEBREW_LOGS}/#{formula.name}/*"]).empty?
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
class CompilerSelectionError < RuntimeError
  def initialize(formula)
    super <<-EOS.undent
      #{formula.name} cannot be built with any available compilers.
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
class ErrorDuringExecution < RuntimeError
  def initialize(cmd, args=[])
    args = args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
    super "Failure while executing: #{cmd} #{args}"
  end
end

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
  def initialize(formula, resource)
    super "#{formula.name} does not define resource #{resource.inspect}"
  end
end

class DuplicateResourceError < ArgumentError
  def initialize(resource)
    super "Resource #{resource.inspect} is defined more than once"
  end
end

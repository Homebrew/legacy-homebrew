class UsageError < RuntimeError; end
class FormulaUnspecifiedError < UsageError; end
class KegUnspecifiedError < UsageError; end

class MultipleVersionsInstalledError < RuntimeError
  attr_reader :name

  def initialize(name)
    @name = name
    super "#{name} has multiple installed versions"
  end
end

class NotAKegError < RuntimeError; end

class NoSuchKegError < RuntimeError
  attr_reader :name

  def initialize(name)
    @name = name
    super "No such keg: #{HOMEBREW_CELLAR}/#{name}"
  end
end

class FormulaValidationError < StandardError
  attr_reader :attr, :formula

  def initialize(formula, attr, value)
    @attr = attr
    @formula = formula
    super "invalid attribute for formula '#{formula}': #{attr} (#{value.inspect})"
  end
end

class FormulaSpecificationError < StandardError; end

class FormulaUnavailableError < RuntimeError
  attr_reader :name
  attr_accessor :dependent

  def initialize(name)
    @name = name
  end

  def dependent_s
    "(dependency of #{dependent})" if dependent && dependent != name
  end

  def to_s
    "No available formula with the name \"#{name}\" #{dependent_s}"
  end
end

class TapFormulaUnavailableError < FormulaUnavailableError
  attr_reader :tap, :user, :repo

  def initialize(tap, name)
    @tap = tap
    @user = tap.user
    @repo = tap.repo
    super "#{tap}/#{name}"
  end

  def to_s
    s = super
    s += "\nPlease tap it and then try again: brew tap #{tap}" unless tap.installed?
    s
  end
end

class TapFormulaAmbiguityError < RuntimeError
  attr_reader :name, :paths, :formulae

  def initialize(name, paths)
    @name = name
    @paths = paths
    @formulae = paths.map do |path|
      path.to_s =~ HOMEBREW_TAP_PATH_REGEX
      "#{Tap.fetch($1, $2)}/#{path.basename(".rb")}"
    end

    super <<-EOS.undent
      Formulae found in multiple taps: #{formulae.map { |f| "\n       * #{f}" }.join}

      Please use the fully-qualified name e.g. #{formulae.first} to refer the formula.
    EOS
  end
end

class TapFormulaWithOldnameAmbiguityError < RuntimeError
  attr_reader :name, :possible_tap_newname_formulae, :taps

  def initialize(name, possible_tap_newname_formulae)
    @name = name
    @possible_tap_newname_formulae = possible_tap_newname_formulae

    @taps = possible_tap_newname_formulae.map do |newname|
      newname =~ HOMEBREW_TAP_FORMULA_REGEX
      "#{$1}/#{$2}"
    end

    super <<-EOS.undent
      Formulae with '#{name}' old name found in multiple taps: #{taps.map { |t| "\n       * #{t}" }.join}

      Please use the fully-qualified name e.g. #{taps.first}/#{name} to refer the formula or use its new name.
    EOS
  end
end

class TapUnavailableError < RuntimeError
  attr_reader :name

  def initialize(name)
    @name = name

    super <<-EOS.undent
      No available tap #{name}.
    EOS
  end
end

class TapAlreadyTappedError < RuntimeError
  attr_reader :name

  def initialize(name)
    @name = name

    super <<-EOS.undent
      Tap #{name} already tapped.
    EOS
  end
end

class TapPinStatusError < RuntimeError
  attr_reader :name, :pinned

  def initialize(name, pinned)
    @name = name
    @pinned = pinned

    super pinned ? "#{name} is already pinned." : "#{name} is already unpinned."
  end
end

class OperationInProgressError < RuntimeError
  def initialize(name)
    message = <<-EOS.undent
      Operation already in progress for #{name}
      Another active Homebrew process is already using #{name}.
      Please wait for it to finish or terminate it to continue.
      EOS

    super message
  end
end

class CannotInstallFormulaError < RuntimeError; end

class FormulaInstallationAlreadyAttemptedError < RuntimeError
  def initialize(formula)
    super "Formula installation already attempted: #{formula.full_name}"
  end
end

class UnsatisfiedRequirements < RuntimeError
  def initialize(reqs)
    if reqs.length == 1
      super "An unsatisfied requirement failed this build."
    else
      super "Unsatisfied requirements failed this build."
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
    message << "Cannot install #{formula.full_name} because conflicting formulae are installed.\n"
    message.concat conflicts.map { |c| conflict_message(c) } << ""
    message << <<-EOS.undent
      Please `brew unlink #{conflicts.map(&:name)*" "}` before continuing.

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
    args = args.map { |arg| arg.to_s.gsub " ", "\\ " }.join(" ")
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
    if !ARGV.verbose?
      puts
      puts "#{Tty.red}READ THIS#{Tty.reset}: #{Tty.em}#{OS::ISSUES_URL}#{Tty.reset}"
      if formula.tap?
        case formula.tap.name
        when "homebrew/boneyard"
          puts "#{formula} was moved to homebrew-boneyard because it has unfixable issues."
          puts "Please do not file any issues about this. Sorry!"
        else
          if issues_url = formula.tap.issues_url
            puts "If reporting this issue please do so at (not Homebrew/homebrew):"
            puts "  #{issues_url}"
          end
        end
      end
    else
      require "cmd/config"
      require "build_environment"

      ohai "Formula"
      puts "Tap: #{formula.tap}" if formula.tap?
      puts "Path: #{formula.path}"
      ohai "Configuration"
      Homebrew.dump_verbose_config
      ohai "ENV"
      Homebrew.dump_build_env(env)
      puts
      onoe "#{formula.full_name} #{formula.version} did not build"
      unless (logs = Dir["#{formula.logs}/*"]).empty?
        puts "Logs:"
        puts logs.map { |fn| "     #{fn}" }.join("\n")
      end
    end
    puts
    if RUBY_VERSION >= "1.8.7" && issues && issues.any?
      puts "These open issues may also help:"
      puts issues.map { |i| "#{i["title"]} #{i["html_url"]}" }.join("\n")
    end

    require "diagnostic"
    unsupported_osx = Homebrew::Diagnostic::Checks.new.check_for_unsupported_osx
    opoo unsupported_osx if unsupported_osx
  end
end

# raised by FormulaInstaller.check_dependencies_bottled and
# FormulaInstaller.install if the formula or its dependencies are not bottled
# and are being installed on a system without necessary build tools
class BuildToolsError < RuntimeError
  def initialize(formulae)
    if formulae.length > 1
      formula_text = "formulae"
      package_text = "binary packages"
    else
      formula_text = "formula"
      package_text = "a binary package"
    end

    if MacOS.version >= "10.10"
      xcode_text = <<-EOS.undent
        To continue, you must install Xcode from the App Store,
        or the CLT by running:
          xcode-select --install
      EOS
    elsif MacOS.version == "10.9"
      xcode_text = <<-EOS.undent
        To continue, you must install Xcode from:
          https://developer.apple.com/downloads/
        or the CLT by running:
          xcode-select --install
      EOS
    elsif MacOS.version >= "10.7"
      xcode_text = <<-EOS.undent
        To continue, you must install Xcode or the CLT from:
          https://developer.apple.com/downloads/
      EOS
    else
      xcode_text = <<-EOS.undent
        To continue, you must install Xcode from:
          https://developer.apple.com/xcode/downloads/
      EOS
    end

    super <<-EOS.undent
      The following #{formula_text}:
        #{formulae.join(", ")}
      cannot be installed as a #{package_text} and must be built from source.
      #{xcode_text}
    EOS
  end
end

# raised by Homebrew.install, Homebrew.reinstall, and Homebrew.upgrade
# if the user passes any flags/environment that would case a bottle-only
# installation on a system without build tools to fail
class BuildFlagsError < RuntimeError
  def initialize(flags)
    if flags.length > 1
      flag_text = "flags"
      require_text = "require"
    else
      flag_text = "flag"
      require_text = "requires"
    end

    if MacOS.version >= "10.10"
      xcode_text = <<-EOS.undent
        or install Xcode from the App Store, or the CLT by running:
          xcode-select --install
      EOS
    elsif MacOS.version == "10.9"
      xcode_text = <<-EOS.undent
        or install Xcode from:
          https://developer.apple.com/downloads/
        or the CLT by running:
          xcode-select --install
      EOS
    elsif MacOS.version >= "10.7"
      xcode_text = <<-EOS.undent
        or install Xcode or the CLT from:
          https://developer.apple.com/downloads/
      EOS
    else
      xcode_text = <<-EOS.undent
        or install Xcode from:
          https://developer.apple.com/xcode/downloads/
      EOS
    end

    super <<-EOS.undent
      The following #{flag_text}:
        #{flags.join(", ")}
      #{require_text} building tools, but none are installed.
      Either remove the #{flag_text} to attempt bottle installation,
      #{xcode_text}
    EOS
  end
end

# raised by CompilerSelector if the formula fails with all of
# the compilers available on the user's system
class CompilerSelectionError < RuntimeError
  def initialize(formula)
    super <<-EOS.undent
      #{formula.full_name} cannot be built with any available compilers.
      To install this formula, you may need to:
        brew install gcc
      EOS
  end
end

# Raised in Resource.fetch
class DownloadError < RuntimeError
  def initialize(resource, cause)
    super <<-EOS.undent
      Failed to download resource #{resource.download_name.inspect}
      #{cause.message}
      EOS
    set_backtrace(cause.backtrace)
  end
end

# raised in CurlDownloadStrategy.fetch
class CurlDownloadStrategyError < RuntimeError
  def initialize(url)
    case url
    when %r{^file://(.+)}
      super "File does not exist: #{$1}"
    else
      super "Download failed: #{url}"
    end
  end
end

# raised by safe_system in utils.rb
class ErrorDuringExecution < RuntimeError
  def initialize(cmd, args = [])
    args = args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
    super "Failure while executing: #{cmd} #{args}"
  end
end

# raised by Pathname#verify_checksum when "expected" is nil or empty
class ChecksumMissingError < ArgumentError; end

# raised by Pathname#verify_checksum when verification fails
class ChecksumMismatchError < RuntimeError
  attr_reader :expected, :hash_type

  def initialize(fn, expected, actual)
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
    super "#{formula.full_name} does not define resource #{resource.inspect}"
  end
end

class DuplicateResourceError < ArgumentError
  def initialize(resource)
    super "Resource #{resource.inspect} is defined more than once"
  end
end

# raised when a single patch file is not found and apply hasn't been specified
class MissingApplyError < RuntimeError ; end

class BottleVersionMismatchError < RuntimeError
  def initialize(bottle_file, bottle_version, formula, formula_version)
    super <<-EOS.undent
      Bottle version mismatch
      Bottle: #{bottle_file} (#{bottle_version})
      Formula: #{formula.full_name} (#{formula_version})
    EOS
  end
end

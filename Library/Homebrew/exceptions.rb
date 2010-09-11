
class NotAKegError < RuntimeError
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
    def initialize formula
      @formula = formula
    end
    def initialize formula, message
      super message
      @formula = formula
    end
  end
end

class FormulaAlreadyInstalledError < Homebrew::InstallationError
  def message
    "Formula already installed: #{formula}"
  end
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
    @formula = formula
  end

  def message
    <<-EOS.undent
      Unsatisfied dependency: #{formula}
      Homebrew does not provide #{type.to_s.capitalize} dependencies, #{tool} does:

          #{command_line} #{formula}
      EOS
  end

  private

  def tool
    case type
      when :python then 'pip'
      when :ruby, :jruby then 'rubygems'
      when :perl then 'cpan'
    end
  end

  def command_line
    case type
      when :python
        "#{brew_pip}pip install"
      when :ruby
        "gem install"
      when :perl
        "cpan -i"
      when :jruby
        "jruby -S gem install"
    end
  end

  def brew_pip
    'brew install pip && ' unless Formula.factory('pip').installed?
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
    args = args.map{ |arg| arg.gsub " ", "\\ " }.join(" ")
    super formula, "Failed executing: #{command} #{args}"
  end

  def was_running_configure?
    @command == './configure'
  end
end

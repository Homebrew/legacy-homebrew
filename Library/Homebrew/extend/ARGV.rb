class UsageError <RuntimeError; end
class FormulaUnspecifiedError <UsageError; end
class KegUnspecifiedError <UsageError; end

module HomebrewArgvExtension
  def named
    @named ||= reject{|arg| arg[0..0] == '-'}
  end
  def options
    select {|arg| arg[0..0] == '-'}
  end
  def formulae
    require 'formula'
    @formulae ||= downcased_unique_named.collect {|name| Formula.factory name}
    raise FormulaUnspecifiedError if @formulae.empty?
    @formulae
  end
  def kegs
    require 'keg'
    @kegs ||= downcased_unique_named.collect do |name|
      d=HOMEBREW_CELLAR+name
      dirs = d.children.select{ |pn| pn.directory? } rescue []
      raise "#{name} is not installed" if not d.directory? or dirs.length == 0
      raise "#{name} has multiple installed versions" if dirs.length > 1
      Keg.new dirs.first
    end
    raise KegUnspecifiedError if @kegs.empty?
    @kegs
  end

  # self documenting perhaps?
  def include? arg
    @n=index arg
  end
  def next
    at @n+1 or raise UsageError
  end

  def force?
    flag? '--force'
  end
  def verbose?
    flag? '--verbose' or ENV['HOMEBREW_VERBOSE']
  end
  def debug?
    flag? '--debug' or ENV['HOMEBREW_DEBUG']
  end
  def quieter?
    flag? '--quieter'
  end
  def interactive?
    flag? '--interactive'
  end
  def build_head?
    flag? '--HEAD'
  end

  def flag? flag
    options.each do |arg|
      return true if arg == flag
      next if arg[1..1] == '-'
      return true if arg.include? flag[2..2]
    end
    return false
  end

  def usage; <<-EOS.undent
    Usage: brew command [formula] ...
    Usage: brew [--prefix] [--cache] [--version|-v]
    Usage: brew [--verbose|-v]

    Principle Commands:
      install formula ... [--ignore-dependencies] [--HEAD|-H]
      list [--unbrewed] [formula] ...
      search [/regex/] [substring]
      uninstall formula ...
      update

    Other Commands:
      cleanup [formula]
      home formula ...
      info [formula] [--github]
      link formula ...
      outdated
      prune
      unlink formula ...

    Commands useful when contributing:
      create URL
      edit [formula]
      log formula
      install formula [--debug|-d] [--interactive|-i] [--verbose|-v]

    For more information:
      man brew

    To visit the Homebrew homepage type:
      brew home
    EOS
  end

  private

  def downcased_unique_named
    @downcased_unique_named ||= named.collect{|arg| arg.downcase}.uniq
  end
end

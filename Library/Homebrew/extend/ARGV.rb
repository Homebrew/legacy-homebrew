#
# extend/ARGV.rb - Interprets arguments passed to brew.
#

module HomebrewArgvExtension
  #
  # Return all of the named arguments (not beginning with '-').
  #
  def named
    @named ||= reject{|arg| arg[0..0] == '-' }
  end

  # 
  # Return all of the option arguments (they begin with '-').
  # 
  def options_only
    select {|arg| arg[0..0] == '-' }
  end

  #
  # Return all valid named formulae.
  # 
  def formulae
    require 'formula'

    @formulae ||= downcased_unique_named.map{|name| Formula.factory(Formula.resolve_alias(name)) }
    raise FormulaUnspecifiedError if @formulae.empty?
    @formulae
  end
  
  #
  # Return all valid named kegs.
  #
  def kegs
    require 'keg'
    require 'formula'

    @kegs ||= downcased_unique_named.collect do |name|
      d = HOMEBREW_CELLAR + Formula.resolve_alias(name)
      dirs = d.children.select{|pn| pn.directory? } rescue []
      raise "No such keg: #{HOMEBREW_CELLAR}/#{name}" if not d.directory? or dirs.length == 0
      # TODO: multiple version handling
      raise "#{name} has multiple installed versions" if dirs.length > 1
      Keg.new dirs.first
    end
    raise KegUnspecifiedError if @kegs.empty?
    @kegs
  end

  #
  # Return the index of the given argument if it was passed.
  #
  def include? arg
    @n = index arg
  end
  
  #
  # Return the argument after the included one.
  # 
  def next
    at @n + 1 or raise UsageError
  end

  #
  # True if the --force (-f) flag was passed.
  #   (Force command to proceed despite warnings.)
  # 
  def force?
    flag? '--force'
  end
  
  #
  # True if the --verbose (-v) flag was passed.
  #   (Prints all build output.)
  #
  def verbose?
    flag? '--verbose' or ENV['HOMEBREW_VERBOSE']
  end
  
  #
  # True if the --debug (-d) flag was passed.
  #   (Dumps the user into an interactive shell if something goes wrong.)
  #
  def debug?
    flag? '--debug' or ENV['HOMEBREW_DEBUG']
  end
  
  #
  # True if the --quieter (-q) flag was passed.
  #
  #
  def quieter?
    flag? '--quieter'
  end
  
  #
  # True if the --interactive (-i) flag was passed.
  #   (Install takes place in an interactive shell.)
  #
  def interactive?
    flag? '--interactive'
  end
  
  #
  # True if the --HEAD (-H) flag was passed.
  #   (Build the development branch of a formula from SCM.)
  #
  def build_head?
    flag? '--HEAD'
  end

  #
  # True if the flag was passed. Works with long flags (e.g. --force) and 
  # abbreviated flags (-f). Each expected flag must have a unique first letter.
  #
  def flag? flag
    options_only.each do |arg|
      return true if arg == flag
      next if arg[1..1] == '-'
      return true if arg.include? flag[2..2]
    end
    return false
  end

  # 
  # Return the usage string for brew.
  # 
  def usage
    <<-EOS.undent
    Usage: brew [-v|--version] [--prefix [formula]] [--cache [formula]]
                [--cellar [formula]] [--config] [--env] [--repository]
                [-h|--help] COMMAND [formula] ...

    Principle Commands:
      install formula ... [--ignore-dependencies] [--HEAD]
      list [--unbrewed|--versions] [formula] ...
      search [/regex/] [substring]
      uninstall formula ...
      update

    Other Commands:
      info formula [--github]
      options formula
      deps formula
      uses formula [--installed]
      home formula ...
      cleanup [formula]
      link formula ...
      unlink formula ...
      outdated
      missing
      prune
      doctor

    Informational:
      --version
      --config
      --prefix [formula]
      --cache [formula]

    Commands useful when contributing:
      create URL
      edit [formula]
      audit [formula]
      log formula
      install formula [-vd|-i]

    For more information:
      man brew

    To visit the Homebrew homepage type:
      brew home
    EOS
  end

  private
  #
  # Return all non-option arguments, downcasing and removing duplicates.
  #
  def downcased_unique_named
    @downcased_unique_named ||= named.map{|arg| arg.downcase}.uniq
  end
end

#
# An error resulting from incorrect use of the brew command.
# 
class UsageError <RuntimeError
end

#
# For actions that require a formula, thrown if no forumla is specified.
# 
class FormulaUnspecifiedError <UsageError
end

#
# For actions that require a keg, thrown if none is specified.
# 
class KegUnspecifiedError <UsageError
end


module HomebrewArgvExtension
  def named
    @named ||= reject{|arg| arg[0..0] == '-'}
  end

  def options_only
    select {|arg| arg[0..0] == '-'}
  end

  def formulae
    require 'formula'
    @formulae ||= downcased_unique_named.map{ |name| Formula.factory name }
    raise FormulaUnspecifiedError if @formulae.empty?
    @formulae
  end

  def kegs
    require 'keg'
    require 'formula'
    @kegs ||= downcased_unique_named.collect do |name|
      d = HOMEBREW_CELLAR+Formula.canonical_name(name)
      dirs = d.children.select{ |pn| pn.directory? } rescue []
      raise NoSuchKegError.new(name) if not d.directory? or dirs.length == 0
      raise MultipleVersionsInstalledError.new(name) if dirs.length > 1
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
  def one?
    flag? '--1'
  end

  def build_head?
    flag? '--HEAD'
  end

  def build_universal?
    include? '--universal'
  end

  def build_from_source?
    return true if flag? '--build-from-source' or ENV['HOMEBREW_BUILD_FROM_SOURCE'] \
      or not MacOS.lion? or HOMEBREW_PREFIX.to_s != '/usr/local'
    options = options_only
    options.delete '--universal'
    not options.empty?
  end

  def flag? flag
    options_only.each do |arg|
      return true if arg == flag
      next if arg[1..1] == '-'
      return true if arg.include? flag[2..2]
    end
    return false
  end

  def usage
    require 'cmd/help'
    Homebrew.help_s
  end

  private

  def downcased_unique_named
    # Only lowercase names, not paths or URLs
    @downcased_unique_named ||= named.map do |arg|
      arg.include?("/") ? arg : arg.downcase
    end.uniq
  end
end

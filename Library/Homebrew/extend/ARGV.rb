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
    return @formulae
  end

  def kegs
    rack = nil
    require 'keg'
    require 'formula'
    @kegs ||= downcased_unique_named.collect do |name|
      canonical_name = Formula.canonical_name(name)
      rack = HOMEBREW_CELLAR + if canonical_name.include? "/"
        # canonical_name returns a path if it was a formula installed via a
        # URL. And we only want the name. FIXME that function is insane.
        Pathname.new(canonical_name).stem
      else
        canonical_name
      end
      dirs = rack.children.select{ |pn| pn.directory? } rescue []
      raise NoSuchKegError.new(name) if not rack.directory? or dirs.length == 0

      linked_keg_ref = HOMEBREW_REPOSITORY/"Library/LinkedKegs"/name

      if not linked_keg_ref.symlink?
        if dirs.length == 1
          Keg.new(dirs.first)
        else
          prefix = Formula.factory(canonical_name).prefix
          if prefix.directory?
            Keg.new(prefix)
          else
            raise MultipleVersionsInstalledError.new(name)
          end
        end
      else
        Keg.new(linked_keg_ref.realpath)
      end
    end
  rescue FormulaUnavailableError
    if rack
      raise <<-EOS.undent
        Multiple kegs installed to #{rack}
        However we don't know which one you refer to.
        Please delete (with rm -rf!) all but one and then try again.
        Sorry, we know this is lame.
      EOS
    else
      raise
    end
  end

  # self documenting perhaps?
  def include? arg
    @n=index arg
  end
  def next
    at @n+1 or raise UsageError
  end

  def value arg
    arg = find {|o| o =~ /--#{arg}=(.+)/}
    $1 if arg
  end

  def force?
    flag? '--force'
  end
  def verbose?
    flag? '--verbose' or !ENV['VERBOSE'].nil? or !ENV['HOMEBREW_VERBOSE'].nil?
  end
  def debug?
    flag? '--debug' or !ENV['HOMEBREW_DEBUG'].nil?
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
  def dry_run?
    include?('--dry-run') || switch?('n')
  end

  def homebrew_developer?
    include? '--homebrew-developer' or !ENV['HOMEBREW_DEVELOPER'].nil?
  end

  def ignore_deps?
    include? '--ignore-dependencies'
  end

  def json
    value 'json'
  end

  def build_head?
    include? '--HEAD'
  end

  def build_devel?
    include? '--devel'
  end

  def build_stable?
    not (build_head? or build_devel?)
  end

  def build_universal?
    include? '--universal'
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    include? '--32-bit'
  end

  def build_bottle?
    include? '--build-bottle' or !ENV['HOMEBREW_BUILD_BOTTLE'].nil?
  end

  def bottle_arch
    arch = value 'bottle-arch'
    arch.to_sym if arch
  end

  def build_from_source?
    include? '--build-from-source' or !ENV['HOMEBREW_BUILD_FROM_SOURCE'].nil? \
      or build_head? or build_devel? or build_universal? or build_bottle?
  end

  def flag? flag
    options_only.any? do |arg|
      arg == flag || arg[1..1] != '-' && arg.include?(flag[2..2])
    end
  end

  def force_bottle?
    include? '--force-bottle'
  end

  # eg. `foo -ns -i --bar` has three switches, n, s and i
  def switch? switch_character
    return false if switch_character.length > 1
    options_only.any? do |arg|
      arg[1..1] != '-' && arg.include?(switch_character)
    end
  end

  def usage
    require 'cmd/help'
    Homebrew.help_s
  end

  def filter_for_dependencies
    # Clears some flags that affect installation, yields to a block, then
    # restores to original state.
    old_args = clone

    flags_to_clear = %w[
      --build-bottle
      --debug -d
      --devel
      --fresh
      --interactive -i
      --HEAD
    ]
    flags_to_clear.concat %w[--verbose -v] if quieter?
    flags_to_clear.each {|flag| delete flag}

    yield
  ensure
    replace(old_args)
  end

  def cc
    value 'cc'
  end

  private

  def downcased_unique_named
    # Only lowercase names, not paths or URLs
    @downcased_unique_named ||= named.map do |arg|
      arg.include?("/") ? arg : arg.downcase
    end.uniq
  end
end

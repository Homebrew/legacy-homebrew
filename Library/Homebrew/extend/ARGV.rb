module HomebrewArgvExtension
  def named
    @named ||= reject{|arg| arg[0..0] == '-'}
  end

  def options_only
    select {|arg| arg[0..0] == '-'}
  end

  def formulae
    require "formula"
    @formulae ||= downcased_unique_named.map { |name| Formulary.factory(name, spec) }
  end

  def kegs
    rack = nil
    require 'keg'
    require 'formula'
    @kegs ||= downcased_unique_named.collect do |name|
      canonical_name = Formulary.canonical_name(name)
      rack = HOMEBREW_CELLAR/canonical_name
      dirs = rack.directory? ? rack.subdirs : []

      raise NoSuchKegError.new(rack.basename.to_s) if not rack.directory? or dirs.empty?

      linked_keg_ref = HOMEBREW_REPOSITORY/"Library/LinkedKegs"/name
      opt_prefix = HOMEBREW_PREFIX/"opt"/name

      if opt_prefix.symlink? && opt_prefix.directory?
        Keg.new(opt_prefix.resolved_path)
      elsif linked_keg_ref.symlink? && linked_keg_ref.directory?
        Keg.new(linked_keg_ref.resolved_path)
      elsif dirs.length == 1
        Keg.new(dirs.first)
      elsif (prefix = Formulary.factory(canonical_name).prefix).directory?
        Keg.new(prefix)
      else
        raise MultipleVersionsInstalledError.new(name)
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

  def only_deps?
    include? '--only-dependencies'
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
    include? '--build-from-source' or !ENV['HOMEBREW_BUILD_FROM_SOURCE'].nil?
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

  def cc
    value 'cc'
  end

  def env
    value 'env'
  end

  def spec
    if include?("--HEAD")
      :head
    elsif include?("--devel")
      :devel
    else
      :stable
    end
  end

  private

  def downcased_unique_named
    # Only lowercase names, not paths or URLs
    @downcased_unique_named ||= named.map do |arg|
      arg.include?("/") ? arg : arg.downcase
    end.uniq
  end
end

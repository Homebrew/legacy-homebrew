require 'tab'
require 'os/mac'
require 'extend/ARGV'
require 'bottle_version'

def bottle_filename f, options={}
  options = { :tag => bottle_tag }.merge(options)
  name = f.name.downcase
  version = f.stable.version
  options[:revision] ||= f.bottle.revision.to_i if f.bottle
  "#{name}-#{version}#{bottle_native_suffix(options)}"
end

def install_bottle? f, options={:warn=>false}
  return true if f.local_bottle_path
  return false if ARGV.build_from_source?
  return true if ARGV.force_bottle?
  return false unless f.pour_bottle?
  return false unless f.default_build?
  return false unless bottle_current?(f)
  if f.bottle.cellar != :any && f.bottle.cellar != HOMEBREW_CELLAR.to_s
    if options[:warn]
      opoo "Building source; cellar of #{f}'s bottle is #{f.bottle.cellar}"
    end
    return false
  end

  true
end

def built_as_bottle? f
  return false unless f.installed?
  tab = Tab.for_keg(f.installed_prefix)
  tab.built_as_bottle
end

def bottle_current? f
  f.bottle and f.bottle.url and not f.bottle.checksum.empty?
end

def bottle_file_outdated? f, file
  filename = file.basename.to_s
  return nil unless f and f.bottle and f.bottle.url \
    and filename.match(bottle_regex)

  bottle_ext = filename[bottle_native_regex, 1]
  bottle_url_ext = f.bottle.url[bottle_native_regex, 1]

  bottle_ext && bottle_url_ext && bottle_ext != bottle_url_ext
end

def bottle_native_suffix options={}
  options = { :tag => bottle_tag }.merge(options)
  ".#{options[:tag]}#{bottle_suffix(options[:revision])}"
end

def bottle_suffix revision=nil
  revision = revision.to_i > 0 ? ".#{revision}" : ""
  ".bottle#{revision}.tar.gz"
end

def bottle_native_regex
  /(\.#{bottle_tag}\.bottle\.(\d+\.)?tar\.gz)$/o
end

def bottle_regex
  Pathname::BOTTLE_EXTNAME_RX
end

def bottle_root_url f
  root_url = f.bottle.root_url
  root_url ||= 'https://downloads.sf.net/project/machomebrew/Bottles'
end

def bottle_url f, tag=bottle_tag
  "#{bottle_root_url(f)}/#{bottle_filename(f, {:tag => tag})}"
end

def bottle_tag
  if MacOS.version >= :lion
    MacOS.cat
  elsif MacOS.version == :snow_leopard
    Hardware::CPU.is_64_bit? ? :snow_leopard : :snow_leopard_32
  else
    # Return, e.g., :tiger_g3, :leopard_g5_64, :leopard_64 (which is Intel)
    if Hardware::CPU.type == :ppc
      tag = "#{MacOS.cat}_#{Hardware::CPU.family}".to_sym
    else
      tag = MacOS.cat
    end
    MacOS.prefer_64_bit? ? "#{tag}_64".to_sym : tag
  end
end

def bottle_filename_formula_name filename
  path = Pathname.new filename
  version = BottleVersion.parse(path).to_s
  basename = path.basename.to_s
  basename.rpartition("-#{version}").first
end

class BottleCollector
  def initialize
    @bottles = {}
  end

  def add(checksum, tag, url=nil)
    @bottles[tag] = checksum
  end

  def fetch_bottle_for(tag)
    return [@bottles[tag], tag] if @bottles[tag]

    find_altivec_tag(tag) || find_or_later_tag(tag)
  end

  def keys; @bottles.keys; end
  def [](arg); @bottles[arg]; end

  # This allows generic Altivec PPC bottles to be supported in some
  # formulae, while also allowing specific bottles in others; e.g.,
  # sometimes a formula has just :tiger_altivec, other times it has
  # :tiger_g4, :tiger_g5, etc.
  def find_altivec_tag(tag)
    if tag.to_s =~ /(\w+)_(g4|g4e|g5)$/
      altitag = "#{$1}_altivec".to_sym
      return [@bottles[altitag], altitag] if @bottles[altitag]
    end
  end

  # Allows a bottle tag to specify a specific OS or later,
  # so the same bottle can target multiple OSs.
  # Not used in core, used in taps.
  def find_or_later_tag(tag)
    results = @bottles.find_all {|k,v| k.to_s =~ /_or_later$/}
    results.each do |key, hsh|
      later_tag = key.to_s[/(\w+)_or_later$/, 1].to_sym
      bottle_version = MacOS::Version.from_symbol(later_tag)
      return [hsh, key] if bottle_version <= MacOS::Version.from_symbol(tag)
    end

    nil
  end
end

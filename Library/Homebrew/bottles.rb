require 'tab'
require 'extend/ARGV'

def bottle_filename f, bottle_version=nil
  name = f.name.downcase
  version = f.version || f.standard.detect_version
  bottle_version = bottle_version || f.bottle_version
  "#{name}-#{version}#{bottle_native_suffix(bottle_version)}"
end

def bottles_supported?
  HOMEBREW_PREFIX.to_s == '/usr/local' and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar' and Hardware.is_64_bit? || !MacOS.snow_leopard?
end

def install_bottle? f
  return true if ARGV.include? '--install-bottle'
  not ARGV.build_from_source? && bottle_current?(f)
end

def built_bottle? f
  Tab.for_formula(f).built_bottle
end

def bottle_current? f
  puts Pathname.new(f.bottle_url).version
  puts f.version
  f.bottle_url && f.bottle_sha1 && Pathname.new(f.bottle_url).version == f.version
end

def bottle_new_version f
  return 0 unless bottle_current? f
  f.bottle_version + 1
end

def bottle_native_suffix version=nil
  ".#{MacOS.cat}#{bottle_suffix(version)}"
end

def bottle_suffix version=nil
  version = version.to_i > 0 ? ".#{version}" : ""
  ".bottle#{version}.tar.gz"
end

def bottle_native_regex
  /(\.#{MacOS.cat}\.bottle\.((\d+)?\.tar\.gz))$/
end

def bottle_regex
  /(\.[a-z]+\.bottle\.(\d+\.)?tar\.gz)$/
end

def old_bottle_regex
  /((\.[a-z]+)?[\.-]bottle\.tar\.gz)$/
end

def bottle_base_url
  "https://downloads.sf.net/project/machomebrew/Bottles/"
end

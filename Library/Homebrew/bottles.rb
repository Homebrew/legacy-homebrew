require 'tab'
require 'extend/ARGV'

def bottle_filename f, bottle_version=nil
  name = f.name.downcase
  version = f.version || f.standard.detect_version
  bottle_version = bottle_version || f.bottle_version
  bottle_version_tag = bottle_version > 0 ? "-#{bottle_version}" : ""
  "#{name}-#{version}#{bottle_version_tag}#{bottle_native_suffix}"
end

def bottles_supported?
  HOMEBREW_PREFIX.to_s == '/usr/local' and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar' and Hardware.is_64_bit? || !MacOS.snow_leopard?
end

def install_bottle? f
  return true if ARGV.include? '--install-bottle'
  !ARGV.build_from_source? && bottle_current?(f)
end

def built_bottle? f
  Tab.for_formula(f).built_bottle
end

def bottle_current? f
  f.bottle_url && f.bottle_sha1 && Pathname.new(f.bottle_url).version == f.version
end

def bottle_new_version f
  return 0 unless bottle_current? f
  f.bottle_version + 1
end

def bottle_native_suffix
  ".#{MacOS.cat}#{bottle_suffix}"
end

def bottle_suffix
  ".bottle.tar.gz"
end

def bottle_native_regex
  /((-\d+)?\.#{MacOS.cat}\.bottle\.tar\.gz)$/
end

def bottle_regex
  /((-\d+)?\.[a-z]+\.bottle\.tar\.gz)$/
end

def old_bottle_regex
  /(-bottle\.tar\.gz)$/
end

def bottle_base_url
  "https://downloads.sf.net/project/machomebrew/Bottles/"
end

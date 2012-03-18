require 'tab'
require 'extend/ARGV'

def bottle_filename f
  "#{f.name}-#{f.version}#{bottle_native_suffix}"
end

def bottles_supported?
  HOMEBREW_PREFIX.to_s == '/usr/local' and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar'
end

def install_bottle? f
  !ARGV.build_from_source? && bottle_current?(f)
end

def built_bottle? f
  Tab.for_formula(f).built_bottle
end

def bottle_current? f
  f.bottle_url && f.bottle_sha1 && Pathname.new(f.bottle_url).version == f.version
end

def bottle_native_suffix
  ".#{MacOS.cat}#{bottle_suffix}"
end

def bottle_suffix
  ".bottle.tar.gz"
end

def bottle_native_regex
  /(\.#{MacOS.cat}\.bottle\.tar\.gz)$/
end

def bottle_regex
  /(\.[a-z]+\.bottle\.tar\.gz)$/
end

def old_bottle_regex
  /(-bottle\.tar\.gz)$/
end

def bottle_base_url
  "https://downloads.sf.net/project/machomebrew/Bottles/"
end

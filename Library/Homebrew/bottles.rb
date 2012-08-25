require 'tab'
require 'extend/ARGV'

def bottle_filename f, bottle_version=nil
  name = f.name.downcase
  version = f.stable.version
  bottle_version ||= f.bottle.revision.to_i
  "#{name}-#{version}#{bottle_native_suffix(bottle_version)}"
end

def bottles_supported?
  HOMEBREW_PREFIX.to_s == '/usr/local' and HOMEBREW_CELLAR.to_s == '/usr/local/Cellar' and Hardware.is_64_bit? || !MacOS.snow_leopard?
end

def install_bottle? f
  return true if ARGV.include? '--install-bottle'
  not ARGV.build_from_source? and bottle_current?(f)
end

def built_as_bottle? f
  f = Formula.factory f unless f.kind_of? Formula
  return false unless f.installed?
  tab = Tab.for_keg(f.installed_prefix)
  # Need to still use the old "built_bottle" until all bottles are updated.
  tab.built_as_bottle or tab.built_bottle
end

def bottle_current? f
  f.bottle and f.bottle.url && !f.bottle.checksum.empty? && f.bottle.version == f.stable.version
end

def bottle_file_outdated? f, file
  filename = file.basename.to_s
  return nil unless (filename.match(bottle_regex) or filename.match(old_bottle_regex)) and f.bottle and f.bottle.url

  bottle_ext = filename.match(bottle_native_regex).captures.first rescue nil
  bottle_ext ||= filename.match(old_bottle_regex).captures.first rescue nil
  bottle_url_ext = f.bottle.url.match(bottle_native_regex).captures.first rescue nil
  bottle_url_ext ||= f.bottle.url.match(old_bottle_regex).captures.first rescue nil

  bottle_ext && bottle_url_ext && bottle_ext != bottle_url_ext
end

def bottle_new_version f
  return 0 unless bottle_current? f
  f.bottle.revision + 1
end

def bottle_native_suffix version=nil
  ".#{MacOS.cat}#{bottle_suffix(version)}"
end

def bottle_suffix version=nil
  version = version.to_i > 0 ? ".#{version}" : ""
  ".bottle#{version}.tar.gz"
end

def bottle_native_regex
  /(\.#{MacOS.cat}\.bottle\.(\d+\.)?tar\.gz)$/
end

def bottle_regex
  Pathname::BOTTLE_EXTNAME_RX
end

def old_bottle_regex
  Pathname::OLD_BOTTLE_EXTNAME_RX
end

def bottle_base_url
  "https://downloads.sf.net/project/machomebrew/Bottles/"
end

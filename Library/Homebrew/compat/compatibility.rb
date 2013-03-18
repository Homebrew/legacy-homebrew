## Compatibility layer introduced in 0.8 (refactor)

# maybe never used by anyone, but alas it must continue to exist
def versions_of(keg_name)
  `/bin/ls #{HOMEBREW_CELLAR}/#{keg_name}`.collect { |version| version.strip }.reverse
end

def dump_config
  require 'cmd/--config'
  Homebrew.__config
end

def dump_build_env env
  require 'cmd/--env'
  Homebrew.dump_build_env env
end

def default_cc
  MacOS.default_cc
end

def gcc_42_build
  MacOS.gcc_42_build_version
end

alias :gcc_build :gcc_42_build

def gcc_40_build
  MacOS.gcc_40_build_version
end

def llvm_build
  MacOS.llvm_build_version
end

def x11_installed?
  MacOS::X11.installed?
end

def macports_or_fink_installed?
  MacOS.macports_or_fink_installed?
end

def outdated_brews
  require 'cmd/outdated'
  Homebrew.outdated_brews
end

def search_brews text
  require 'cmd/search'
  Homebrew.search_brews text
end

def snow_leopard_64?
  MacOS.prefer_64_bit?
end

class Formula
  # in compatability because the naming is somewhat confusing
  def self.resolve_alias name
    opoo 'Formula.resolve_alias is deprecated and will eventually be removed'
    opoo 'Use Formula.canonical_name instead.'

    # Don't resolve paths or URLs
    return name if name.include?("/")

    aka = HOMEBREW_REPOSITORY+"Library/Aliases"+name
    if aka.file?
      aka.realpath.basename('.rb').to_s
    else
      name
    end
  end

  # This used to be called in "def install", but should now be used
  # up in the DSL section.
  def fails_with_llvm msg=nil, data=nil
    opoo "Calling fails_with_llvm in the install method is deprecated"
    puts "Use the fails_with DSL instead"
  end

  def fails_with_llvm?
    fails_with? :llvm
  end

  def self.fails_with_llvm msg=nil, data={}
    case msg when Hash then data = msg end
    failure = CompilerFailure.new(:llvm) { build(data.delete(:build).to_i) }
    @cc_failures ||= Set.new
    @cc_failures << failure
  end

  def std_cmake_parameters
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -DCMAKE_FIND_FRAMEWORK=LAST -Wno-dev"
  end

  class << self
    def bottle_sha1 val=nil
      val.nil? ? @bottle_sha1 : @bottle_sha1 = val
    end
  end

  # These methods return lists of Formula objects.
  # They are eprecated in favor of Dependency::expand_dependencies
  # and Formula#recursive_dependencies, which return lists of
  # Dependency objects instead.
  def self.expand_deps f
    f.deps.map do |dep|
      f_dep = Formula.factory dep.to_s
      expand_deps(f_dep) << f_dep
    end
  end

  def recursive_deps
    Formula.expand_deps(self).flatten.uniq
  end
end

class UnidentifiedFormula < Formula
end

module HomebrewEnvExtension extend self
  def use_clang?
    compiler == :clang
  end

  def use_gcc?
    compiler == :gcc
  end

  def use_llvm?
    compiler == :llvm
  end
end

# TODO eventually some of these should print deprecation warnings
module MacOS extend self
  def xcode_folder
    Xcode.folder
  end

  def xcode_prefix
    Xcode.prefix
  end

  def xcode_installed?
    Xcode.installed?
  end

  def xcode_version
    Xcode.version
  end

  def clt_installed?
    CLT.installed?
  end

  def clt_version?
    CLT.version
  end

  def x11_installed?
    X11.installed?
  end

  def x11_prefix
    X11.prefix
  end

  def leopard?
    10.5 == MACOS_VERSION
  end

  def snow_leopard?
    10.6 <= MACOS_VERSION # Actually Snow Leopard or newer
  end
  alias_method :snow_leopard_or_newer?, :snow_leopard?

  def lion?
    10.7 <= MACOS_VERSION # Actually Lion or newer
  end
  alias_method :lion_or_newer?, :lion?

  def mountain_lion?
    10.8 <= MACOS_VERSION # Actually Mountain Lion or newer
  end
  alias_method :mountain_lion_or_newer?, :mountain_lion?

  def macports_or_fink_installed?
    not MacOS.macports_or_fink.empty?
  end
end


class Version
  def slice *args
    opoo "Calling slice on versions is deprecated, use: to_s.slice"
    to_s.slice(*args)
  end
end


# MD5 support
class Formula
  def self.md5(val)
    @stable ||= SoftwareSpec.new
    @stable.md5(val)
  end
end

class SoftwareSpec
  def md5(val)
    @checksum = Checksum.new(:md5, val)
  end
end

class Pathname
  def md5
    require 'digest/md5'
    opoo <<-EOS.undent
    MD5 support is deprecated and will be removed in a future version.
    Please switch this formula to #{Checksum::TYPES.map { |t| t.to_s.upcase } * ' or '}.
    EOS
    incremental_hash(Digest::MD5)
  end
end

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
  MacOS.x11_installed?
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
    FailsWithLLVM.new(msg, data).handle_failure
  end

  def fails_with_llvm?
    fails_with? :llvm
  end

  def self.fails_with_llvm msg=nil, data=nil
    fails_with_llvm_reason = FailsWithLLVM.new(msg, data)
    @cc_failures ||= CompilerFailures.new
    @cc_failures << fails_with_llvm_reason
  end

  def std_cmake_parameters
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -DCMAKE_FIND_FRAMEWORK=LAST -Wno-dev"
  end

  class << self
    def bottle_sha1 val=nil
      val.nil? ? @bottle_sha1 : @bottle_sha1 = val
    end
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

class FailsWithLLVM
  attr_reader :compiler, :build, :cause

  def initialize msg=nil, data=nil
    if msg.nil? or msg.kind_of? Hash
      @cause = "(No specific reason was given)"
      data = msg
    else
      @cause = msg
    end
    @build = (data.delete :build rescue nil).to_i
    @compiler = :llvm
  end

  def handle_failure
    return unless ENV.compiler == :llvm

    # version 2336 is the latest version as of Xcode 4.2, so it is the
    # latest version we have tested against so we will switch to GCC and
    # bump this integer when Xcode 4.3 is released. TODO do that!
    if build.to_i >= 2336
      if MacOS.xcode_version < "4.2"
        opoo "Formula will not build with LLVM, using GCC"
        ENV.gcc
      else
        opoo "Formula will not build with LLVM, trying Clang"
        ENV.clang
      end
      return
    end
    opoo "Building with LLVM, but this formula is reported to not work with LLVM:"
    puts
    puts cause
    puts
    puts <<-EOS.undent
      We are continuing anyway so if the build succeeds, please open a ticket with
      the following information: #{MacOS.llvm_build_version}-#{MACOS_VERSION}. So
      that we can update the formula accordingly. Thanks!
      EOS
    puts
    if MacOS.xcode_version < "4.2"
      puts "If it doesn't work you can: brew install --use-gcc"
    else
      puts "If it doesn't work you can try: brew install --use-clang"
    end
    puts
  end
end

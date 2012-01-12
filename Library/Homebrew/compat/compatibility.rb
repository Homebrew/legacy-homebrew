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
    handle_llvm_failure FailsWithLLVM.new(msg, data)
  end
end

class UnidentifiedFormula < Formula
end

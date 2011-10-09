require 'formula'
require 'extend/ENV'
require 'hardware'

ENV_VARIABLES = %w[ CC CXX LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MAKEFLAGS
                    MACOSX_DEPLOYMENT_TARGET PKG_CONFIG_PATH HOMEBREW_DEBUG
                    HOMEBREW_VERBOSE HOMEBREW_USE_CLANG HOMEBREW_USE_GCC
                    HOMEBREW_USE_LLVM HOMEBREW_SVN PATH CMAKE_LIBRARY_PATH ]

module Homebrew extend self
  def env_info
    if ARGV.include? "--help"
      puts <<-EOS
brew env-info

NAME
  brew env-info - for printing enviorment flags of a given formula.

SYNPOSIS
  brew env-info FORMULA... [OPTIONS]  Prints the enviorment variables
                                      appripriate for building and linking
                                      against all of the formula you pass it.

DESCRIPTION
  brew env-info is a tool for generating build flags for packages managed by
  brew. This command will print any settings needed to build against the
  formula you pass the command.

EXAMPLES
  Here is an example of how to use brew env-info.

    $ brew env-info libiconv cairo       Prints the enviorment variables
                                         appripriate for building against
                                         libiconv and cairo.

  If your project uses a Makefile for example you could use the following:

    $ brew env-info libiconv cairo | xargs env make

  Most importantly, this will export CPPFLAGS and LDFLAGS with the correct
  paths for building against both libiconv and cairo, even if they are in
  kegs outside of the normal path structure.

  If you only want to print some of the enviorment variables and not all of the
  enviorment variables you can pass '--env-variable' and it will only print the
  variables in the list you pass, for example:

    $ brew env-info --cppflags libiconv     Causes brew env-info to only print
                                            the CPPFLAGS.

  At the time of writing, this prints out:

    CPPFLAGS="-I/usr/local/Cellar/libiconv/1.14/include"

EOS
      return
    end

    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    ARGV.formulae.each do |f|
      if f.keg_only?
        ENV.prepend 'CMAKE_LIBRARY_PATH', f.prefix, ':'
        ENV.prepend 'LDFLAGS', "-L#{f.lib}"
        ENV.prepend 'CPPFLAGS', "-I#{f.include}"
        ENV.prepend 'PATH', "#{f.bin}", ':'
        ENV.prepend 'PKG_CONFIG_PATH', f.lib+'pkgconfig', ':'
      end
      f.recursive_deps.uniq.each do |dep|
        dep = Formula.factory dep
        if dep.keg_only?
          ENV.prepend 'CMAKE_LIBRARY_PATH', f.prefix, ':'
          ENV.prepend 'LDFLAGS', "-L#{dep.lib}"
          ENV.prepend 'CPPFLAGS', "-I#{dep.include}"
          ENV.prepend 'PATH', "#{dep.bin}", ':'
          ENV.prepend 'PKG_CONFIG_PATH', dep.lib+'pkgconfig', ':'
        end
      end
    end

    ENV_VARIABLES.each do |k|
      next unless ARGV.include? '--' + k.downcase or ARGV.options_only.empty?
      value = ENV[k]
      puts "#{k}=\"#{value}\"" if value
    end
  end
end

Homebrew.env_info

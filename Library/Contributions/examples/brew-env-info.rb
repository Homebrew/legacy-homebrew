require 'formula'
require 'extend/ENV'
require 'hardware'

module Homebrew extend self
  def env_info
    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    ARGV.formulae.each do |f|
      if f.keg_only?
        ENV.prepend 'LDFLAGS', "-L#{f.lib}"
        ENV.prepend 'CPPFLAGS', "-I#{f.include}"
        ENV.prepend 'PATH', "#{f.bin}", ':'
        ENV.prepend 'PKG_CONFIG_PATH', f.lib+'pkgconfig', ':'
      end
      f.recursive_deps.uniq.each do |dep|
        dep = Formula.factory dep
        if dep.keg_only?
          ENV.prepend 'LDFLAGS', "-L#{dep.lib}"
          ENV.prepend 'CPPFLAGS', "-I#{dep.include}"
          ENV.prepend 'PATH', "#{dep.bin}", ':'
          ENV.prepend 'PKG_CONFIG_PATH', dep.lib+'pkgconfig', ':'
        end
      end
    end
    %w[ CC CXX LD ].each do |k|
      value = ENV[k]
      if value
        results = value
        if File.exists? value and File.symlink? value
          target = Pathname.new(value)
          results = target.realpath
        end
        puts "#{k}=\"#{results}\""
      end
    end

    %w[ CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MACOSX_DEPLOYMENT_TARGET MAKEFLAGS PKG_CONFIG_PATH
        HOMEBREW_DEBUG HOMEBREW_VERBOSE HOMEBREW_USE_CLANG HOMEBREW_USE_GCC HOMEBREW_USE_LLVM
        HOMEBREW_SVN ].each do |k|
      value = ENV[k]
      puts "#{k}=\"#{value}\"" if value
    end
  end
end

Homebrew.env_info

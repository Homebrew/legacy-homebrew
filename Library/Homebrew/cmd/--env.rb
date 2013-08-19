require 'extend/ENV'
require 'hardware'

module Homebrew extend self
  def __env
    ENV.activate_extensions!

    if superenv?
      ENV.deps = ARGV.formulae.map(&:name) unless ARGV.named.empty?
    end
    ENV.setup_build_environment
    ENV.universal_binary if ARGV.build_universal?
    if $stdout.tty?
      dump_build_env ENV
    else
      keys = build_env_keys(ENV) << 'HOMEBREW_BREW_FILE' << 'HOMEBREW_SDKROOT'
      keys.each do |key|
        puts "export #{key}=\"#{ENV[key]}\""
      end
    end
  end

  def build_env_keys env
    %w[
      CC CXX LD
      HOMEBREW_CC
      CFLAGS CXXFLAGS CPPFLAGS LDFLAGS SDKROOT MAKEFLAGS
      CMAKE_PREFIX_PATH CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_FRAMEWORK_PATH
      MACOSX_DEPLOYMENT_TARGET PKG_CONFIG_PATH PKG_CONFIG_LIBDIR
      HOMEBREW_DEBUG HOMEBREW_MAKE_JOBS HOMEBREW_VERBOSE HOMEBREW_USE_CLANG
      HOMEBREW_USE_GCC HOMEBREW_USE_LLVM HOMEBREW_SVN HOMEBREW_GIT
      HOMEBREW_SDKROOT HOMEBREW_BUILD_FROM_SOURCE
      MAKE GIT CPP
      ACLOCAL_PATH OBJC PATH CPATH].select{ |key| env.fetch(key) if env.key? key }
  end

  def dump_build_env env
    build_env_keys(env).each do |key|
      case key when 'CC', 'CXX'
        next
      end if superenv?

      value = env[key]
      print "#{key}: #{value}"
      case key when 'CC', 'CXX', 'LD'
        if value =~ %r{/usr/bin/xcrun (.*)}
          path = `/usr/bin/xcrun -find #{$1}`
          print " => #{path}"
        elsif File.symlink? value
          print " => #{Pathname.new(value).realpath}"
        end
      end
      puts
    end
  end
end

require "extend/ENV"

module Homebrew
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
      build_env_keys(ENV).each do |key|
        puts "export #{key}=\"#{ENV[key]}\""
      end
    end
  end

  def build_env_keys env
    %w[
      CC CXX LD OBJC OBJCXX
      HOMEBREW_CC HOMEBREW_CXX
      CFLAGS CXXFLAGS CPPFLAGS LDFLAGS SDKROOT MAKEFLAGS
      CMAKE_PREFIX_PATH CMAKE_INCLUDE_PATH CMAKE_LIBRARY_PATH CMAKE_FRAMEWORK_PATH
      MACOSX_DEPLOYMENT_TARGET PKG_CONFIG_PATH PKG_CONFIG_LIBDIR
      HOMEBREW_DEBUG HOMEBREW_MAKE_JOBS HOMEBREW_VERBOSE
      HOMEBREW_SVN HOMEBREW_GIT
      HOMEBREW_SDKROOT HOMEBREW_BUILD_FROM_SOURCE
      MAKE GIT CPP
      ACLOCAL_PATH PATH CPATH].select { |key| env.key?(key) }
  end

  def dump_build_env env
    keys = build_env_keys(env)

    if env["CC"] == env["HOMEBREW_CC"]
      %w[CC CXX OBJC OBJCXX].each { |key| keys.delete(key) }
    end

    keys.each do |key|
      value = env[key]
      print "#{key}: #{value}"
      case key
      when "CC", "CXX", "LD"
        print " => #{Pathname.new(value).realpath}" if File.symlink?(value)
      end
      puts
    end
  end
end

require 'extend/ENV'
require 'hardware'

module Homebrew extend self
  def __env
    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    ENV.universal_binary if ARGV.build_universal?
    dump_build_env ENV
  end

  def dump_build_env env
    puts %["--use-clang" was specified] if ARGV.include? '--use-clang'
    puts %["--use-llvm" was specified] if ARGV.include? '--use-llvm'
    puts %["--use-gcc" was specified] if ARGV.include? '--use-gcc'

    %w[ CC CXX LD ].each do |k|
      value = env[k]
      if value
        results = value
        if value =~ %r{/usr/bin/xcrun (.*)}
          path = `/usr/bin/xcrun -find #{$1}`
          results += " => #{path}"
        elsif File.exists? value and File.symlink? value
          results += " => #{Pathname.new(value).realpath}"
        end
        puts "#{k}: #{results}"
      end
    end

    %w[ CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MACOSX_DEPLOYMENT_TARGET MAKEFLAGS PKG_CONFIG_PATH
        HOMEBREW_BUILD_FROM_SOURCE HOMEBREW_DEBUG HOMEBREW_MAKE_JOBS HOMEBREW_VERBOSE
        HOMEBREW_USE_CLANG HOMEBREW_USE_GCC HOMEBREW_USE_LLVM HOMEBREW_SVN ].each do |k|
      value = env[k]
      puts "#{k}: #{value}" if value
    end
  end
end

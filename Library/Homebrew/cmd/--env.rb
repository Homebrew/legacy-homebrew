require 'extend/ENV'
require 'hardware'

module Homebrew extend self
  def __env
    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    dump_build_env ENV
  end

  def dump_build_env env
    puts %["--use-llvm" was specified] if ARGV.include? '--use-llvm'

    %w[ CC CXX LD ].each do |k|
      value = env[k]
      if value
        results = value
        if File.exists? value and File.symlink? value
          target = Pathname.new(value)
          results += " => #{target.realpath}"
        end
        puts "#{k}: #{results}"
      end
    end

    %w[ CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MACOSX_DEPLOYMENT_TARGET MAKEFLAGS PKG_CONFIG_PATH
        HOMEBREW_DEBUG HOMEBREW_VERBOSE HOMEBREW_USE_LLVM HOMEBREW_SVN ].each do |k|
      value = env[k]
      puts "#{k}: #{value}" if value
    end
  end
end

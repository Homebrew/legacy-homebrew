require "extend/ENV"
require "build_environment"

module Homebrew
  def __env
    ENV.activate_extensions!
    ENV.deps = ARGV.formulae if superenv?
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
end

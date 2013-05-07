require "formula"

module Homebrew extend self
  module LogCommand extend self
    def find_formulae_paths(repository)
      paths = []
      if ARGV.named.empty?
        Dir.chdir(repository)
      else
        formulae = ARGV.formulae
        raise "Can't show logs for formulae from different repositories" if !same_tap?(formulae)
        paths += formulae.map { |formula| formula.path.realpath }
        Dir.chdir(paths[0].dirname)
      end
      return paths
    end

    def find_args
      options = ARGV.options_only
      repository = HOMEBREW_REPOSITORY
      tap_option = options.find { |option| option =~ /--tap=(\w+)\/(\w+)/ }
      if tap_option
        repository = Formula.tap_path($1, $2)
        raise "No such tap!" if !repository.directory?
        options.delete(tap_option)
      end
      paths = find_formulae_paths(repository)
      raise "Don't use the --tap option when specifying a list of formulae" if tap_option && paths.any?
      return options + paths
    end

    protected

    def same_tap?(formulae)
      return true if formulae.size <= 1
      tap = formulae[0].tap
      return !formulae[1..-1].any? { |formula| formula.tap != tap }
    end
  end

  def log
    exec("git", "log", *LogCommand.find_args)
  end
end

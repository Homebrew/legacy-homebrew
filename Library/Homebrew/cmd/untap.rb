require 'cmd/tap' # for tap_args

module Homebrew extend self
  def untap
    raise "Usage is `brew untap <tap-name>`" if ARGV.empty?

    user, repo = tap_args

    # we consistently downcase in tap to ensure we are not bitten by case-insensive
    # filesystem issues. Which is the default on mac. The problem being the
    # filesystem cares, but our regexps don't. So unless we resolve *every* path
    # we will get bitten.
    user.downcase!
    repo.downcase!

    tapd = HOMEBREW_LIBRARY/"Taps/#{user}/homebrew-#{repo}"

    raise "No such tap!" unless tapd.directory?

    files = []
    tapd.find_formula{ |file| files << Pathname.new("#{user}/homebrew-#{repo}").join(file) }
    unlink_tap_formula(files)
    tapd.rmtree
    tapd.dirname.rmdir_if_possible
    puts "Untapped #{files.length} formula"
  end

  def unlink_tap_formula formulae
    untapped = 0
    gitignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []

    formulae.each do |formula|
      file = HOMEBREW_LIBRARY.join("Taps", formula)
      link = HOMEBREW_LIBRARY.join("Formula", formula.basename)

      if link.symlink? && (!link.exist? || link.resolved_path == file)
        link.delete
        gitignores.delete(file.basename.to_s)
        untapped += 1
      end
    end

    HOMEBREW_REPOSITORY.join("Library/Formula/.gitignore").atomic_write(gitignores * "\n")

    untapped
  end
end

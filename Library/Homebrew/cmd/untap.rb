require 'cmd/tap' # for tap_args

module Homebrew extend self
  def untap
    user, repo = tap_args
    tapd = HOMEBREW_LIBRARY/"Taps/#{user}-#{repo}"

    raise "No such tap!" unless tapd.directory?

    gitignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []
    untapped = 0

    tapd.find_formula do |pn|
      bn = pn.basename.to_s
      pn = HOMEBREW_LIBRARY/"Formula/#{bn}"
      if pn.symlink? and pn.realpath.to_s =~ %r[^#{tapd.realpath}]
        pn.delete
        gitignores.delete(bn)
        untapped += 1
      end
    end
    rm_rf tapd

    HOMEBREW_REPOSITORY.join("Library/Formula/.gitignore").atomic_write(gitignores * "\n")

    puts "Untapped #{untapped} formula"
  end
end

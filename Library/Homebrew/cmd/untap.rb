require 'cmd/tap' # for tap_args

module Homebrew extend self
  def untap
    user, repo = tap_args
    tapd = HOMEBREW_LIBRARY/"Taps/#{user}-#{repo}"

    raise "No such tap!" unless tapd.directory?

    gitignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []

    tapd.find_formula do |pn|
      bn = pn.basename.to_s
      pn = HOMEBREW_LIBRARY/"Formula/#{bn}"
      pn.delete if pn.symlink? and pn.realpath.to_s =~ %r[^#{tapd.realpath}]
      gitignores.delete(bn)
    end
    rm_rf tapd

    HOMEBREW_REPOSITORY.join("Library/Formula/.gitignore").atomic_write(gitignores * "\n")
  end
end

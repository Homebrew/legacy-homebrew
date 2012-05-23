require 'cmd/tap' # for tap_args

module Homebrew extend self
  def untap
    clone_url, tapd_name = tap_args(true)

    tapd_name = "direct_#{ARGV.first}" unless tapd_name

    # we consistently downcase in tap to ensure we are not bitten by case-insensive
    # filesystem issues. Which is the default on mac. The problem being the
    # filesystem cares, but our regexps don't. So unless we resolve *every* path
    # we will get bitten.
    tapd_name.downcase!

    tapd = HOMEBREW_LIBRARY/"Taps/#{tapd_name}"

    raise "No such tap!" unless tapd.directory?

    files = []
    tapd.find_formula{ |file| files << Pathname.new(tapd_name).join(file) }
    untapped = unlink_tap_formula(files)
    rm_rf tapd
    puts "Untapped #{untapped} formula"
  end

  def unlink_tap_formula formulae
    untapped = 0
    gitignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []

    formulae.each do |formula|
      tapd = (HOMEBREW_LIBRARY/"Taps/#{formula}").dirname
      bn = formula.basename.to_s
      pn = HOMEBREW_LIBRARY/"Formula/#{bn}"

      if pn.symlink? and (!pn.exist? or pn.realpath.to_s =~ %r[^#{tapd}])
        pn.delete
        gitignores.delete(bn)
        untapped += 1
      end
    end

    HOMEBREW_REPOSITORY.join("Library/Formula/.gitignore").atomic_write(gitignores * "\n")

    untapped
  end
end

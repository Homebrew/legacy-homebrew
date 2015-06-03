require 'cmd/tap' # for tap_args and show_taps

module Homebrew
  def untap
    if ARGV.empty?
      show_taps
    else
      ARGV.each do |tapname|
        user, repo = tap_args(tapname)

        # we consistently downcase in tap to ensure we are not bitten by
        # case-insensive filesystem issues. Which is the default on mac. The
        # problem being the filesystem cares, but our regexps don't. So unless
        # we resolve *every* path we will get bitten.
        user.downcase!
        repo.downcase!

        tapd = HOMEBREW_LIBRARY/"Taps/#{user}/homebrew-#{repo}"

        raise "No such tap!" unless tapd.directory?
        puts "Untapping #{tapname}... (#{tapd.abv})"

        files = []
        tapd.find_formula { |file| files << file }
        tapd.rmtree
        tapd.dirname.rmdir_if_possible
        puts "Untapped #{files.length} formula#{plural(files.length, 'e')}"
      end
    end
  end
end

require 'cmd/tap' # for Pathname.recursive_formula

module Homebrew extend self
  def untap
    user, repo = tap_args
    tapd = HOMEBREW_PREFIX/"Library/Taps/#{user}-#{repo}"

    raise "No such tap!" unless tapd.directory?

    tapd.find_formula do |pn|
      pn = HOMEBREW_REPOSITORY/"Library/Formula"/pn.basename
      pn.delete if pn.symlink? and pn.realpath.to_s =~ %r[^#{tapd.realpath}]
    end

    rm_rf tapd
  end
end

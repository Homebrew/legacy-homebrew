require 'formula'

class GitSh < Formula
  url 'http://github.com/rtomayko/git-sh/tarball/a6eba8824586ce34aff9907af448b3336f7c83d2'
  homepage 'http://github.com/rtomayko/git-sh'
  md5 '061c56717564651dd99f5cd14b2b1569'
  version '20100401'
  head 'git://github.com/rtomayko/git-sh.git'

  # Not depending on git because people might have it
  # installed through another means

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end

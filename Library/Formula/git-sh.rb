require 'formula'

class GitSh < Formula
  url 'https://github.com/rtomayko/git-sh/tarball/800769328ed381638c13e6eec2c3b21a58d74867'
  homepage 'https://github.com/rtomayko/git-sh'
  md5 'f736b2c6aea13140af4011672c7d11c3'
  version '20110918'
  head 'https://github.com/rtomayko/git-sh.git'

  # Not depending on git because people might have it
  # installed through another means

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end

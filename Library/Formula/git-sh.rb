require 'formula'

class GitSh < Formula
  homepage 'https://github.com/rtomayko/git-sh'
  url 'https://github.com/rtomayko/git-sh/tarball/800769328ed381638c13e6eec2c3b21a58d74867'
  version '20110918'
  md5 'f736b2c6aea13140af4011672c7d11c3'

  head 'https://github.com/rtomayko/git-sh.git'

  # Pending request for new tag:
  # https://github.com/rtomayko/git-sh/issues/16

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

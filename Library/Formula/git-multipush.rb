require 'formula'

class GitMultipush < Formula
  url 'http://git-multipush.googlecode.com/files/git-multipush-1.0.tar.bz2'
  homepage 'http://code.google.com/p/git-multipush/'
  md5 'ca809d24857c5abe92f870f3a4f2ebe5'

  # Not depending on git because people might have it
  # installed through another means

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end

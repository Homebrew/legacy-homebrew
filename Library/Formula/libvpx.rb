require 'formula'

class Libvpx < Formula
  url 'http://webm.googlecode.com/files/libvpx-v0.9.7.tar.bz2'
  sha1 '639596df7182a93db83f61af8f5bb5b6a13dcf63'
  homepage 'http://www.webmproject.org/code/'

  depends_on 'yasm' => :build

  def install
    args = ["--prefix=#{prefix}"]
    # Configure detects 32-bit CPUs incorrectly.
    args << "--target=generic-gnu" unless MacOS.prefer_64_bit?

    system "./configure", *args
    system "make install"
  end
end

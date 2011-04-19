require 'formula'

class Libvpx < Formula
  url 'http://webm.googlecode.com/files/libvpx-v0.9.6.tar.bz2'
  sha1 'a3522bd2b73d52381ba767ded1cbf4760e9cc6f8'
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

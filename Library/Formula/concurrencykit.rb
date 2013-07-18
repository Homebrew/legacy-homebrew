require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.2.20.tar.gz'
  sha1 'bc99f50a99061b1a1310fee7200591c35fcbcc36'

  head 'git://git.concurrencykit.org/ck.git'

  option 'enable-pointer-packing', 'Build with pointer-packing enabled'
  option 'enable-rtm',             'Build with support for Intel TSX'
  option 'run-check',              'Run regression suite (takes long time)'

  def install
    args = [ "--prefix=#{prefix}" ]
    args << '--enable-pointer-packing' if build.include? 'enable-pointer-packing'
    args << '--enable-rtm'             if build.include? 'enable-rtm'
    system "./configure", *args
    system "make", "CC=#{ENV.cc}"
    system "make install"
    system "make check" if build.include? 'run-check'
  end
end

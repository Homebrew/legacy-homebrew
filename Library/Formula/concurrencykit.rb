require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.2.15.tar.gz'
  sha1 'eea1aef0178f4d728164b3b2dda8ebededc62832'

  head 'git://git.concurrencykit.org/ck.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end

require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.3.1.tar.gz'
  sha1 'ca8fb6cf2a7562c012dffd579ac8f8ed051e6ed4'

  head 'git://git.concurrencykit.org/ck.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
  end
end

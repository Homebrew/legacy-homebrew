require 'formula'

class Getxbook < Formula
  homepage 'http://njw.me.uk/software/getxbook/'
  url 'http://njw.me.uk/software/getxbook/getxbook-1.0.tar.bz2'
  sha1 '6408bf4e680856c67b5977d9ba73730cd7bde3e6'

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end
end

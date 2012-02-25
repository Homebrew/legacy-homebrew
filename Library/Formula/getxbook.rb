require 'formula'

class Getxbook < Formula
  url 'http://njw.me.uk/software/getxbook/getxbook-0.6.tar.bz2'
  homepage 'http://njw.me.uk/software/getxbook/'
  md5 'd19826109c6590072c3784bf49e7f4ba'

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end
end

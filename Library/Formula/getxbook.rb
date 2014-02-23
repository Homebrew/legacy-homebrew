require 'formula'

class Getxbook < Formula
  homepage 'http://njw.me.uk/software/getxbook/'
  url 'http://njw.me.uk/software/getxbook/getxbook-1.1.tar.bz2'
  sha1 '9d47918ed77e8fb4f4e8b3c412cdcc82834be3e8'

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end
end

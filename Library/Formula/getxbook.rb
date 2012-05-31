require 'formula'

class Getxbook < Formula
  homepage 'http://njw.me.uk/software/getxbook/'
  url 'http://njw.me.uk/software/getxbook/getxbook-0.9.tar.bz2'
  sha1 '833b37fd121b24090ce59424886571be4bedf6c2'

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "install"
  end
end

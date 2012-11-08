require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Dhcping < Formula
  homepage 'http://www.mavetju.org'
  url 'http://www.mavetju.org/download/dhcping-1.2.tar.gz'
  sha1 '97927886adc1e5b3a67c55f9010a918e2e880f1e'

  def install

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "true"
  end
end

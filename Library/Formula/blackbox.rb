require 'formula'

class Blackbox < Formula
  homepage 'http://www.cs.rochester.edu/u/kautz/satplan/blackbox/'
  url 'http://www.cs.rochester.edu/u/kautz/satplan/blackbox/Blackbox44.tgz'
  sha1 '6e61cf9bbb1f28f2dd9f77f9be59fb6fd4fae224'

  def install
    system "make"
    bin.install 'blackbox'
  end
end

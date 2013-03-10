require 'formula'

class Dvorak7min < Formula
  homepage 'http://dvorak7min.sourcearchive.com/'
  url 'http://dvorak7min.sourcearchive.com/downloads/1.6.1-13.1/dvorak7min_1.6.1.orig.tar.gz'
  version '1.6.1'
  sha1 '83f7ec4eba3fa33cf0547a8614ee02e50ff21c81'

  def install
    system "make"
    system "make INSTALL=#{prefix}/bin install"
  end
end

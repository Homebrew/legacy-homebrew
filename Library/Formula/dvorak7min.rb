require 'formula'

class Dvorak7min < Formula
  homepage 'http://dvorak7min.sourcearchive.com/'
  url 'http://dvorak7min.sourcearchive.com/downloads/1.6.1-13.1/dvorak7min_1.6.1.orig.tar.gz'
  version '1.6.1'
  sha1 'e531ce2e6c64a4867f5bb7e03d64f8fbb0ce8707'

  def install
    system "make clean"
    system "make"
    system "make INSTALL=#{prefix}/bin install"
  end
end

require 'formula'

class Mhash < Formula
  url 'http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz'
  homepage 'http://mhash.sourceforge.net/'
  sha1 'c898de5ea60d9e0873a1b73caa031bb1b5797c03'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

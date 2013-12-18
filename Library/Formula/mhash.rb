require 'formula'

class Mhash < Formula
  homepage 'http://mhash.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz'
  sha1 'c898de5ea60d9e0873a1b73caa031bb1b5797c03'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

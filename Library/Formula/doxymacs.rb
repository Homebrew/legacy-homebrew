require 'formula'

class Doxymacs < Formula
  url 'http://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz'
  homepage 'http://doxymacs.sourceforge.net/'
  sha1 'b2aafb4f2d20ceb63614c2b9f06d79dd484d8e2e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

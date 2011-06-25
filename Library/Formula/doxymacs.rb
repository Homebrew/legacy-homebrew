require 'formula'

class Doxymacs < Formula
  url 'http://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz'
  homepage 'http://doxymacs.sourceforge.net/'
  md5 'a2c1750efdec955f42e410a18ebd4eb8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Esniper < Formula
  homepage 'http://sourceforge.net/projects/esniper/'
  url 'http://downloads.sourceforge.net/project/esniper/esniper/2.28.0/esniper-2-28-0.tgz'
  version '2.28'
  sha1 'f5c367ab08565597f1808f9141706dcb3abfcffc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Esniper < Formula
  homepage 'http://sourceforge.net/projects/esniper/'
  url 'https://downloads.sourceforge.net/project/esniper/esniper/2.29.0/esniper-2-29-0.tgz'
  version '2.29'
  sha1 'e08bf08c05f99768f3b8ca52065ad5573eb40770'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Esniper < Formula
  homepage 'http://sourceforge.net/projects/esniper/'
  url 'http://downloads.sourceforge.net/project/esniper/esniper/2.27.0/esniper-2-27-0.tgz'
  version '2.27'
  sha1 ''

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

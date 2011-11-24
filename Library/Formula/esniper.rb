require 'formula'

class Esniper < Formula
  url 'http://downloads.sourceforge.net/project/esniper/esniper/2.26.0/esniper-2-26-0.tgz'
  homepage 'http://sourceforge.net/projects/esniper/'
  md5 '5ea4ae725691fd2178abebb2ba3ee516'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

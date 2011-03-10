require 'formula'

class Libical < Formula
  url 'http://downloads.sourceforge.net/project/freeassociation/libical/libical-0.46/libical-0.46.tar.gz'
  homepage 'http://www.citadel.org/doku.php/documentation:featured_projects:libical'
  md5 '9c08f88945bfd5d0791d102e4aa4125c'

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

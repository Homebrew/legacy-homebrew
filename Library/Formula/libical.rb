require 'formula'

class Libical < Formula
  homepage 'http://www.citadel.org/doku.php/documentation:featured_projects:libical'
  url 'http://downloads.sourceforge.net/project/freeassociation/libical/libical-0.48/libical-0.48.tar.gz'
  sha1 '4693cd0438be9f3727146ac1a46aa5b1b93b8c86'

  depends_on :automake
  depends_on :libtool

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

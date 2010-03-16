require 'formula'

class Libical <Formula
  url 'http://downloads.sourceforge.net/project/freeassociation/libical/libical-0.44/libical-0.44.tar.gz'
  homepage 'http://www.citadel.org/doku.php/documentation:featured_projects:libical'
  md5 'e0403c31e1ed82569325685f8c15959c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

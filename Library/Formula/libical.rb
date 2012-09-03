require 'formula'

class Libical < Formula
  url 'http://downloads.sourceforge.net/project/freeassociation/libical/libical-0.46/libical-0.46.tar.gz'
  homepage 'http://www.citadel.org/doku.php/documentation:featured_projects:libical'
  sha1 'a2a9cad21e0c336246100eef8d079cbaff50a6f3'

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

require 'formula'

class Libical < Formula
  homepage 'http://www.citadel.org/doku.php/documentation:featured_projects:libical'
  url 'http://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz'
  sha1 '25c75f6f947edb6347404a958b1444cceeb9f117'

  depends_on :automake
  depends_on :libtool

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

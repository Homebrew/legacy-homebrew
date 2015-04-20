require 'formula'

class Libdiscid < Formula
  homepage 'http://musicbrainz.org/doc/libdiscid'
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz'
  sha1 '4e682d24bceeb35c19800f9141348d77eae133f2'

  bottle do
    cellar :any
    revision 1
    sha1 "9ee7ba15bd468b30cb205a3480d2e3f3fd5da9c9" => :yosemite
    sha1 "8713a0550c2410728a2f9b7f127339dd223ad63c" => :mavericks
    sha1 "7147e8ff42ddd2f44aa93e6eb06497e2d60c4fb4" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end

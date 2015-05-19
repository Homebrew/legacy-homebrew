require 'formula'

class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage 'http://flactag.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz'
  sha1 'eb62b3b8657fe26c6f838b0098fd4f176ccb454d'

  depends_on 'pkg-config' => :build
  depends_on 'asciidoc' => :build
  depends_on 'flac'
  depends_on 'libmusicbrainz'
  depends_on 'neon'
  depends_on 'libdiscid'
  depends_on 's-lang'
  depends_on 'unac'
  depends_on 'jpeg'

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/flactag"
  end
end

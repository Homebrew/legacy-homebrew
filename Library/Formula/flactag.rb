class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "http://flactag.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "flac"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "libdiscid"
  depends_on "s-lang"
  depends_on "unac"
  depends_on "jpeg"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end

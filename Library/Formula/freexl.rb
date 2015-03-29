class Freexl < Formula
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.1.tar.gz"
  sha256 "df0127e1e23e9ac9a189c27880fb71207837e8cba93d21084356491c9934b89b"

  option "without-check", "Skip compile-time make checks."

  depends_on "doxygen" => [:optional, :build]

  bottle do
    cellar :any
    revision 1
    sha1 "0158f6a76dcf1fd8ab569f2689a745fefc61fc90" => :yosemite
    sha1 "7a90c3a51e61ebbc1a5f46eae6483bbb3dc4517f" => :mavericks
    sha1 "effe1c8fda7ae09b761e3388962cb59e676459b5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "check"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end
end

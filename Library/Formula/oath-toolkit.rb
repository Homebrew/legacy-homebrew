class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.0.tar.gz"
  mirror "http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.0.tar.gz"
  sha256 "2346cb8a2fc75ea56934cb9867463001665772308f2d9e7fe487159d38960926"

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

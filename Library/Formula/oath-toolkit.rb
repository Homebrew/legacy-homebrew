class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.0.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.0.tar.gz"
  sha256 "2346cb8a2fc75ea56934cb9867463001665772308f2d9e7fe487159d38960926"

  bottle do
    sha256 "e9631ace23f064754302813192003e0032405265d0feb30ed725cf72bd412976" => :yosemite
    sha256 "c288201dd37a7290ee995b57a5857099fe876fa2808c054a6cc4bfbda70fb07d" => :mavericks
    sha256 "af35cf7a4e69382dfd0d9c00b62e83d194e36a0b3a8e9a22f1aca21f56bd4153" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.18/at-spi2-atk-2.18.0.tar.xz"
  sha256 "4a6db33453b6efd15fa7d84ef2a3421262a053f57f1df6e7a2536d02bacdf375"

  bottle do
    cellar :any
    sha256 "6450a0feacc584653cffd568de196344757c5c0c186a666304b54913b415e3df" => :el_capitan
    sha256 "dfde79b25b559649c16c2a5734a10c21a88ec557cfa3a8cf5c87014258793c4a" => :yosemite
    sha256 "429671113826d9f00ae043a52a7f3be80d886d25ef0ef0fa8b50b33a5c6f7c94" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

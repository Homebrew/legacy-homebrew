class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.18/at-spi2-atk-2.18.0.tar.xz"
  sha256 "4a6db33453b6efd15fa7d84ef2a3421262a053f57f1df6e7a2536d02bacdf375"

  bottle do
    cellar :any
    sha256 "3ea29e85ce012dbc848d27ec6d609cd492479e61b3820773b5e2f56dab7c691f" => :el_capitan
    sha1 "87a7ff21bc3a30210612b0a9967eec0c9cbfe42e" => :yosemite
    sha1 "2dfa3d351cee3cf5b306c11858dcc98ffc629b8f" => :mavericks
    sha1 "a1538c6a67142e6ee84fd3ee87c03328c0fec926" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.14/at-spi2-atk-2.14.1.tar.xz"
  sha256 "058f34ea60edf0a5f831c9f2bdd280fe95c1bcafb76e466e44aa0fb356d17bcb"

  bottle do
    cellar :any
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

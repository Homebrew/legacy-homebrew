class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.20.tar.xz"
  sha256 "e0a170fb264c2ae4cecd852f4e7aaddb8d58e8f3f0b569ce2d2a4704f55bdf65"

  bottle do
    cellar :any
    sha256 "848440f6eaec305993135ee8708b81ad5ae2cfa9cfb5f7e6fcc8f4d077e9eda0" => :el_capitan
    sha1 "0c1a5cbbee06768e007d38b020b1246f766b9915" => :yosemite
    sha1 "d95faea4b6b509c58c848aa06981723317df888a" => :mavericks
    sha1 "d342a6800769b6ecdf0071591bf794ce810cd35b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make", "install"
  end
end

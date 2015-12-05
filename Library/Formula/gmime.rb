class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.20.tar.xz"
  sha256 "e0a170fb264c2ae4cecd852f4e7aaddb8d58e8f3f0b569ce2d2a4704f55bdf65"

  bottle do
    cellar :any
    sha256 "848440f6eaec305993135ee8708b81ad5ae2cfa9cfb5f7e6fcc8f4d077e9eda0" => :el_capitan
    sha256 "445348c5634172858befc936961626d1bc45ee6e6119f11b764032efc1b96687" => :yosemite
    sha256 "be33acb8e9285f2d17a0895fb7c85b0938c517708e81ea3de34a86065f0c49cd" => :mavericks
    sha256 "89e935d9ed23f2c5c426e2f19a112a682e71e805ac89f7faf91f102e24676691" => :mountain_lion
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

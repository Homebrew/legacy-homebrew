require "formula"

class Makedepend < Formula
  homepage "http://x.org"
  url "http://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  sha1 "2599afa039d2070bae9df6ce43da288b3a4adf97"

  bottle do
    cellar :any
    sha1 "83db1daee01e4eb752c711934eb88850b3ee70d6" => :mavericks
    sha1 "9c55ea85af719a448a4522958bd0e57e5e7741d1" => :mountain_lion
    sha1 "66c5cb0f796db17741c38fb98bd2c05c82bf989c" => :lion
  end

  depends_on "pkg-config" => :build

  resource "xproto" do
    url "http://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.25.tar.bz2"
    sha1 "335f84713f9da3f77c48536f53abb9b03bcb3961"
  end

  resource "xorg-macros" do
    url "http://xorg.freedesktop.org/releases/individual/util/util-macros-1.18.0.tar.bz2"
    sha1 "c0b04a082e50bb8d56a904648f61a8f3eea63043"
  end

  def install
    resource("xproto").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{buildpath}/xproto"
      system "make", "install"
    end

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xproto/lib/pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

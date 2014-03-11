require "formula"

class Makedepend < Formula
  homepage "http://x.org"
  url "http://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  sha1 "2599afa039d2070bae9df6ce43da288b3a4adf97"

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

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"
    ENV["X_CFLAGS"] = "-I#{buildpath}/xproto/include"
    ENV["X_LIBS"] = "-L#{buildpath}/xproto/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

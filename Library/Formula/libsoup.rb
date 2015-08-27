class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.48/libsoup-2.48.1.tar.xz"
  sha256 "9b0d14b36e36a3131a06c6e3aa7245716e6904e3e636df81c0b6c8bd3f646f9a"

  bottle do
    sha1 "58bfb3f803cdb164301d33754d80cf0b12b44f4c" => :yosemite
    sha1 "6701311c286723f87dc8699a150b9085f5b14431" => :mavericks
    sha1 "94ad9a680bdd06cb14721217ffbe091c2f46c143" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
  depends_on "gobject-introspection" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check"
    ]

    if build.with? "gobject-introspection"
      args << "--enable-introspection"
    else
      args << "--disable-introspection"
    end

    system "./configure", *args
    system "make", "install"
  end
end

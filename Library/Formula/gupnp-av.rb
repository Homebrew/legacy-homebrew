class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.7.tar.xz"
  sha256 "35e775bc4f7801d65dcb710905a6b8420ce751a239b5651e6d830615dc906ea8"

  bottle do
    sha256 "0b25fc8c3b63454a5cda6c3e4f2b4fe86c66e10e7caa40f3531a4c0d1388c8af" => :yosemite
    sha256 "42533fead634b1017afb8d18750eaf6a4cd6b5eb9d1c64163af5ca0860ed3bf8" => :mavericks
    sha256 "5451437522d43b19f7c3c5a79ecb93cbf7fa3a8ab65db6c0cae43de668f41128" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

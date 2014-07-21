require "formula"

class TelepathyMissionControl < Formula
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.2.tar.gz"
  sha1 "4c15d20b5f06f083a60bcd9b08141e99092863a3"

  bottle do
    sha1 "8235075abe8ce8cb5e9dd93d4d5744c1e6ea631a" => :mavericks
    sha1 "f581cf6c84813819d00976a6bcedb09b001741f2" => :mountain_lion
    sha1 "4411c5f1d032a92620658f1bb976c8d59f83edb2" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "telepathy-glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-connectivity=no
      --disable-debug
      --disable-upower
      --disable-gtk-doc-html
      --disable-static
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make install"
  end
end

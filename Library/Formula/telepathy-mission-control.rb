require "formula"

class TelepathyMissionControl < Formula
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.2.tar.gz"
  sha1 "4c15d20b5f06f083a60bcd9b08141e99092863a3"

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

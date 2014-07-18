require "formula"

class TelepathyIdle < Formula
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-idle/telepathy-idle-0.2.0.tar.gz"
  sha1 "932c11e7c131cc106ef0a6670158535925d9ca9e"

  depends_on "pkg-config" => :build
  depends_on "telepathy-glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make install"
  end
end

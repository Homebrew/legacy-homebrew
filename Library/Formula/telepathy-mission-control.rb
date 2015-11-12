class TelepathyMissionControl < Formula
  desc "Telepathy account manager and channel dispatcher"
  homepage "http://telepathy.freedesktop.org/wiki/Mission_Control/"
  url "http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.2.tar.gz"
  sha256 "3dcbf8d26cd19e77ef9296c9ae501f8af6cd59aeb058f0a3d5eb75e5647268ea"

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
    system "make", "install"
  end
end

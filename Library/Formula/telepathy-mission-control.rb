class TelepathyMissionControl < Formula
  desc "Telepathy account manager and channel dispatcher"
  homepage "http://telepathy.freedesktop.org/wiki/Mission_Control/"
  url "http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.2.tar.gz"
  sha256 "3dcbf8d26cd19e77ef9296c9ae501f8af6cd59aeb058f0a3d5eb75e5647268ea"

  bottle do
    sha256 "f2d98b719cf932f22519326e53e533e2c8ef41757a6a17da3d2d240ff0b379b5" => :mavericks
    sha256 "458d00042ae4c5f52ba4137533743657d13b2fab1e9d8363e1dd3e9a3d90c4ff" => :mountain_lion
    sha256 "215db867b81bb870b55b769e6bd1c6da286dc65b6b35a86d6c09e70a13d60605" => :lion
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

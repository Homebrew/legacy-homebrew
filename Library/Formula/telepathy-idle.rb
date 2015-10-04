class TelepathyIdle < Formula
  desc "Telepathy IRC connection manager"
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-idle/telepathy-idle-0.2.0.tar.gz"
  sha256 "3013ad4b38d14ee630b8cc8ada5e95ccaa849b9a6fe15d2eaf6d0717d76f2fab"

  bottle do
    sha1 "3a6af986bce3a470d02033de44d7e24480acef15" => :mavericks
    sha1 "58c518ecf46e0ca0f74decf1a601a620f3e3418d" => :mountain_lion
    sha1 "c7f27d805fbc6a93ee656daa06d3bc1fb512836b" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "telepathy-glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    system "./configure", *args
    system "make", "install"
  end
end

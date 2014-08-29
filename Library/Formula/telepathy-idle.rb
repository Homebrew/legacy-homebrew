require "formula"

class TelepathyIdle < Formula
  homepage "http://telepathy.freedesktop.org/wiki/Components/"
  url "http://telepathy.freedesktop.org/releases/telepathy-idle/telepathy-idle-0.2.0.tar.gz"
  sha1 "932c11e7c131cc106ef0a6670158535925d9ca9e"

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
    system "make install"
  end
end

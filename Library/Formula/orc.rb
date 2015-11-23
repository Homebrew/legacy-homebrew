class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "http://cgit.freedesktop.org/gstreamer/orc/"
  url "http://gstreamer.freedesktop.org/src/orc/orc-0.4.24.tar.xz"
  sha256 "338cd493b5247300149821c6312bdf7422a3593ae98691fc75d7e4fe727bd39b"

  bottle do
    cellar :any
    sha256 "02b833c92904551374f31c2c05146f1078423d56ddeb3b546035d80fa76f2a11" => :el_capitan
    sha256 "928226e33f369a084c7e60ca0f60bf218d21ba66bf03f1edc8ebff8e3a1add71" => :yosemite
    sha256 "655f2e92674e8364a95450dbedb56bbe591def168638fc0c7ba4478929f803a7" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make", "install"
  end
end

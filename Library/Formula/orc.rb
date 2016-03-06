class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.25.tar.xz"
  sha256 "c1b1d54a58f26d483f0b3881538984789fe5d5460ab8fab74a1cacbd3d1c53d1"

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

  test do
    system "#{bin}/orcc", "--version"
  end
end

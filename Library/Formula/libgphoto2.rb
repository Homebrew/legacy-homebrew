class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  # Sourceforge URL is still down
  url "https://fossies.org/linux/privat/libgphoto2-2.5.8.tar.bz2"
  sha256 "031a262e342fae43f724afe66787947ce1fb483277dfe5a8cf1fbe92c58e27b6"

  bottle do
    sha256 "e2ab27a5a1f46f154507acf0ef0ad7f40b2e9cb09a8bc382839ac500dd7fdf2b" => :el_capitan
    sha256 "c5849c3b1611cd54458134d5ae8d94b1e2faf6c5de8ccbfa446664025678514f" => :yosemite
    sha256 "425d858334ca59eb8219b01017f799954001d86af107c5a7f48480a098ada324" => :mavericks
    sha256 "292b0ae9dfd78befb17b3d54e358cbca0d0f994f6819f888b95aa28dde407d8b" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"
  depends_on "gd"
  depends_on "libexif" => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

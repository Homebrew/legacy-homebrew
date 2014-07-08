require "formula"

class StartupNotification < Formula
  homepage "http://www.freedesktop.org/wiki/Software/startup-notification/"
  url "http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha1 "4198bce2808d03160454a2940d989f3a5dc96dbb"

  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

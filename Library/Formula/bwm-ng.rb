class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "http://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/releases/download/v0.6.1/bwm-ng-0.6.1.tar.gz"
  mirror "http://www.gropp.org/bwm-ng/bwm-ng-0.6.1.tar.gz"
  sha256 "027cf3c960cd96fc9ffacdf7713df62d0fc55eeef4a1388289f8a62ae5e50df0"

  head do
    url "https://github.com/vgropp/bwm-ng.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "<div class=\"bwm-ng-header\">", shell_output("#{bin}/bwm-ng -o html")
  end
end

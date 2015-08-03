class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "http://www.gropp.org/?id=projects&sub=bwm-ng"
  url "http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz"
  sha256 "c1134358e268329d438b0996399003b0f0b966034fb4b5b138761c2f3c62ffdd"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

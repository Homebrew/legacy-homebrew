class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "https://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/releases/download/v0.6.1/bwm-ng-0.6.1.tar.gz"
  mirror "https://www.gropp.org/bwm-ng/bwm-ng-0.6.1.tar.gz"
  sha256 "027cf3c960cd96fc9ffacdf7713df62d0fc55eeef4a1388289f8a62ae5e50df0"

  bottle do
    cellar :any
    sha256 "2b6af853a216dca06b1e692f2f03a453962b384bd5fba7bc8566f277f71d9d5b" => :yosemite
    sha256 "d68545d5c597faccc236df30879008b2902623e6c60d35474f3e9559d8f91d35" => :mavericks
    sha256 "06cb4a90714cfb9ef2abf51ab4c08e18956eead594cf601c947b4cf6ac6bba05" => :mountain_lion
  end

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

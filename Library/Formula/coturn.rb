class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.2/turnserver-4.5.0.2.tar.gz"
  sha256 "435241425002d0fe193090107fb3daa9b6abb138c4f7ed2ad242c4c16c1852ca"

  bottle do
    sha256 "a8fc588ede3007500f2f833acfe8c821fbd8ecf2aecf9281a84f4809ec3b0588" => :el_capitan
    sha256 "8a11b652133c182a68d57fbd483d37b8df2767393e3fc009ca428ccbf7fa9701" => :yosemite
    sha256 "50b48e42bc684d1eb9003227ebf975c1e46e76fcb8602311502a753d301726e6" => :mavericks
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end

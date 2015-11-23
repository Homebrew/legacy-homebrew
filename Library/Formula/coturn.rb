class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.3/turnserver-4.5.0.3.tar.gz"
  sha256 "78726712058dcabb6df670fe02a51f9b30b4d82028d4dfa4f4bb0800c5924f83"

  bottle do
    sha256 "b5aaf335c5f30a5b6f26f5d718db4d6fa705b8e339ced2c6bbac546b92c8a270" => :el_capitan
    sha256 "5aaae6f131ce3ae93a225683848ea10be69b6d2a52cdc4241dcece8bbf578e9e" => :yosemite
    sha256 "61d1a26b4fcf66b9009269c106577a333a6e101eb9b973e6db462d1e33b75a96" => :mavericks
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

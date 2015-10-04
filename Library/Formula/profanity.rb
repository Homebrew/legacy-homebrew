class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.6.tar.gz"
  sha256 "9672667e419958dd75d40cc0f253087ba1ae7df0c3c855eaa780831ad8282a9f"
  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha256 "bd3c590498442f7a6d0714ab17ca9835c2a8d8b4fce25783456b56a3d8f0954f" => :el_capitan
    sha256 "94039c7e967b2db27b9b0ea7b57ecf394b571c5facbf38cc754f9076c86b5f86" => :yosemite
    sha256 "6e137ddb29e94142d988738f491a994137992680b5322f8593656ae87159cc84" => :mavericks
    sha256 "5399f746ca2c82a279ef696ccd3bf7a3e08b8de2f9758668a0c4342132df8b9b" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libstrophe"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "terminal-notifier" => :optional

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end

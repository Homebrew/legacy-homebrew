class Autogen < Formula
  desc "Automated text file generator"
  homepage "http://autogen.sourceforge.net"
  url "http://ftpmirror.gnu.org/autogen/autogen-5.18.7.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autogen/autogen-5.18.7.tar.xz"
  sha256 "a7a580a5e18931cb341b255cec2fee2dfd81bea5ddbf0d8ad722703e19aaa405"

  bottle do
    sha256 "319d4d6c54c3025e590d15553c86ffbe5c2db1c2d7946d5cd8fb4a02786adc27" => :el_capitan
    sha256 "5805b867cab218e2a1a933f646344cec285d883c5c6c9f04dfb90795e21a7dcc" => :yosemite
    sha256 "7a00b94115673c045497246de4f1e5b90cb636ae10fa3aea1409f7e4be52c2dc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end

class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20151120.tar.bz2"
  sha256 "5dfd3fd364a96960e1f57ade4d755474556858653e4ce64265599520378c5f65"

  bottle do
    sha256 "ee1819c80cb867fe912a0e5cd904835c4d5cff2f1258fa677930dcc6c1bd92f2" => :el_capitan
    sha256 "aeee9bd67c7ead873b8b0fda0d839a68ff67e923097dc20c543f52428d50c7a6" => :yosemite
    sha256 "df68185a1cba612196b394b624f49688ecf7a6e71efe7a5f56dc5a03ba8aea5a" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV.append "LIBS", "-liconv"
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end

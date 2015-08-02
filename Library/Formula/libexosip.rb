class Libexosip < Formula
  desc "eXosip2 toolkit"
  homepage "https://www.antisip.com/category/osip-and-exosip-toolkit"
  url "http://download.savannah.gnu.org/releases/exosip/libeXosip2-4.1.0.tar.gz"
  sha256 "3c77713b783f239e3bdda0cc96816a544c41b2c96fa740a20ed322762752969d"

  bottle do
    cellar :any
    revision 1
    sha256 "c77e33eeb31833d443251338d84044ee2ce87863fc4de36604685aaf002057e9" => :yosemite
    sha256 "f650ff7155a07782e895d7c5c6f5f85fcd8dc44e5080be6249a8cc3dad78a4a6" => :mavericks
    sha256 "a229fe8f6e8e4934d8e9af5d5a3e7905da8329dbc35864d34f915751e6fa6d8a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libosip"
  depends_on "openssl"

  def install
    # Extra linker flags are needed to build this on Mac OS X. See:
    # http://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices "\
                          "-framework Security"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

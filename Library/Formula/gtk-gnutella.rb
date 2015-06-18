class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.3/gtk-gnutella-1.1.3.tar.bz2"
  sha256 "2659ddb846f60d13789674e926a71bbb4a8b9d3ca98c6b034a95eaa073531405"

  bottle do
    sha256 "63de0c311d36f4fd819f52b948020bc92b3b931bcb696cef5a15cb197b084faa" => :yosemite
    sha256 "f0761091efbe8563089fcae161063a8f7a2fe06db8de0f4ca66098d69342ac70" => :mavericks
    sha256 "f3c46fcf9dc1af40eb3e278a0e18139b5b9e0033b661c24bcdbc6f30160fdee8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./build.sh",  "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share+"pixmaps"
    rm_rf share+"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end

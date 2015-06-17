class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.3/gtk-gnutella-1.1.3.tar.bz2"
  sha256 "2659ddb846f60d13789674e926a71bbb4a8b9d3ca98c6b034a95eaa073531405"

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

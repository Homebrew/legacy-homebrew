class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.6/gtk-gnutella-1.1.6.tar.bz2"
  sha256 "b755250f6b8af65b449f20e4dac77a677c1c3fd52f603dc9cd82b035740974c3"

  bottle do
    sha256 "d7347bbc5795956804bdf626783544c12689bafefeba7612f2f9a774a697ada2" => :el_capitan
    sha256 "ee7142c75b6bcdd7fcf49f3d2c3878bca658d3e5c23c97ee94c8ec25a8eeddb4" => :yosemite
    sha256 "969fa3c9aa68a5c54c5c116718541d41146b292ddd0f4cadd437340f0115bf91" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end

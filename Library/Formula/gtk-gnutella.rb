class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.1/gtk-gnutella-1.1.1.tar.bz2"
  sha1 "aa4f21fe758f7ac52c15ee0156247443ce8c7d6f"

  bottle do
    revision 1
    sha1 "6c9217247f9a47d82ff9c689c1efd66d0ce17cae" => :yosemite
    sha1 "942fd75c53801f6940ee4f4b5d92eb555f9e1e64" => :mavericks
    sha1 "7be7004be7fa64ad3f7a0ecb63903f9f2d59041d" => :mountain_lion
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
end

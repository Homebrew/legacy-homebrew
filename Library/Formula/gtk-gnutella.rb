class GtkGnutella < Formula
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.1/gtk-gnutella-1.1.1.tar.bz2"
  sha1 "aa4f21fe758f7ac52c15ee0156247443ce8c7d6f"

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

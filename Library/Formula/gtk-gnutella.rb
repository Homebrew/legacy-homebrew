class GtkGnutella < Formula
  homepage "http://gtk-gnutella.sourceforge.net/en/?page=news"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.1/gtk-gnutella-1.1.1.tar.bz2"
  sha1 "aa4f21fe758f7ac52c15ee0156247443ce8c7d6f"

  bottle do
    sha1 "e3f2a8ef6645ff8144b29e19a406a0f6abf70049" => :yosemite
    sha1 "01718be6251ad2952a8bed4dfa4e53d8bb0fbd2e" => :mavericks
    sha1 "df5e849051d70b623139dfa001b586b886cd13b0" => :mountain_lion
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

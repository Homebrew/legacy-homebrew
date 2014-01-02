require 'formula'

class Libgee < Formula
  homepage 'http://live.gnome.org/Libgee'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgee/0.12/libgee-0.12.0.tar.xz'
  sha256 'd106ed63fe0da5d5ee89aa8197a373cf9a2b96688cc3060144bfc0a022496ea5'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

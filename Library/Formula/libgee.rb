require 'formula'

class Libgee < Formula
  homepage 'http://live.gnome.org/Libgee'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgee/0.6/libgee-0.6.5.tar.xz'
  sha256 '99b78db2492c533e386a07bce9aab1de4bdf23284b1a485b893683de388fff48'

  depends_on 'xz' => :build
  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

require 'formula'

class Libgee < Formula
  homepage 'http://live.gnome.org/Libgee'
  url 'http://download.gnome.org/sources/libgee/0.8/libgee-0.8.0.tar.xz'
  sha256 '5e3707cbc1cebea86ab8865682cb28f8f80273869551c3698e396b5dc57831ea'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

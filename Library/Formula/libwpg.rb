require 'formula'

class Libwpg < Formula
  homepage 'http://libwpg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libwpg/libwpg/libwpg-0.2.2/libwpg-0.2.2.tar.bz2'
  sha1 'e9484e795259485ece9a984f60776704d55afeeb'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Separate steps or install can fail due to folders not existing
    system "make"
    ENV.j1
    system "make install"
  end
end

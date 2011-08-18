require 'formula'

class Libmp3splt < Formula
  url 'http://prdownloads.sourceforge.net/mp3splt/libmp3splt-0.7.tar.gz'
  homepage 'http://mp3splt.sourceforge.net/'
  md5 'dadb166361e2a28955032a1b9f10ed38'

  depends_on "pcre"
  depends_on "gettext"
  depends_on "libid3tag"
  depends_on "libmad"
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

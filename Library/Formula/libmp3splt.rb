require 'formula'

class Libmp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.1/libmp3splt-0.7.1.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 '62025951f483334f14f1b9be58162094'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

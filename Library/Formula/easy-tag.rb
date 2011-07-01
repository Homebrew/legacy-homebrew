require 'formula'

class EasyTag < Formula
  url 'http://archive.ubuntu.com/ubuntu/pool/universe/e/easytag/easytag_2.1.6.orig.tar.gz'
  homepage 'http://easytag.sf.net'
  md5 '91b57699ac30c1764af33cc389a64c71'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'id3lib'
  depends_on 'libid3tag'
  depends_on 'mp4v2'

  def install
    # Use mp4v2 instead of mp4
    inreplace ['configure', 'src/mp4_header.c', 'src/mp4_tag.c'],
      "#include <mp4.h>", "#include <mp4v2/mp4v2.h>"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

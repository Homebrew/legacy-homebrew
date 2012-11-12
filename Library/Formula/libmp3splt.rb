require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.3/libmp3splt-0.7.3.tar.gz'
  sha1 '3c26d1f64c8bd525938aa7f12a41817107ed3ded'

  # Linking fails on 10.6 (and lower?) without a duplicate libtool; see #10350
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://sourceforge.net/projects/mp3splt/files/libmp3splt/0.8.1a/libmp3splt-0.8.1a.tar.gz'
  sha1 '5b16e3fa7a092afd185b13a8a0434d779223df1b'

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

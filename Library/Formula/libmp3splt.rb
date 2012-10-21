require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.2/libmp3splt-0.7.2.tar.gz'
  sha1 'b70df9c57aef88d7831a939871b231789f922157'

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

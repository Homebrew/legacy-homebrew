require 'formula'

class Cmus <Formula
  url 'http://downloads.sourceforge.net/project/cmus/cmus-v2.3.4.tar.bz2'
  homepage 'http://cmus.sourceforge.net/'
  md5 '10629719fd0bff2d3c322ac24834af35'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'faad2'
  depends_on 'flac'
  depends_on 'mp4v2'

  skip_clean 'bin/cmus'
  skip_clean 'bin/cmus-remote'

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end

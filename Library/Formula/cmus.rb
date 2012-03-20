require 'formula'

class Cmus < Formula
  url 'http://downloads.sourceforge.net/cmus/cmus-v2.4.3.tar.bz2'
  homepage 'http://cmus.sourceforge.net/'
  md5 '75452cf007637214c4ab5444e076114b'
  head 'https://git.gitorious.org/cmus/cmus.git', :using => :git

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'faad2'
  depends_on 'flac'
  depends_on 'mp4v2'
  depends_on 'libcue' if ARGV.build_head?

  skip_clean 'bin/cmus'
  skip_clean 'bin/cmus-remote'

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end

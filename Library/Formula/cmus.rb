require 'formula'

class Cmus < Formula
  homepage 'http://cmus.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cmus/cmus-v2.5.0.tar.bz2'
  sha1 '244975a5ff642567acb047f6bd518e4a3271c25b'

  head 'https://git.gitorious.org/cmus/cmus.git'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'faad2'
  depends_on 'flac'
  depends_on 'mp4v2'
  depends_on 'libcue'

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end

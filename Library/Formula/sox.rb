require 'formula'

class Sox < Formula
  homepage 'http://sox.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/sox/sox/14.4.1/sox-14.4.1.tar.gz'
  sha1 '71f05afc51e3d9b03376b2f98fd452d3a274d595'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'mad'
  depends_on 'opencore-amr' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'flac' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'libao' => :optional
  depends_on 'lame' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gomp"
    system "make install"
  end
end

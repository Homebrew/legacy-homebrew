require 'formula'

class Sox < Formula
  homepage 'http://sox.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sox/sox/14.4.0/sox-14.4.0.tar.gz'
  sha1 'd809cab382c7a9d015491c69051a9d1c1a1a44f1'

  depends_on 'pkg-config' => :build
  depends_on :libpng
  depends_on 'mad'
  depends_on 'opencore-amr' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'flac' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'libao' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gomp"
    system "make install"
  end
end

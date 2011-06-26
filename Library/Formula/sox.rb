require 'formula'

class Sox < Formula
  url 'http://downloads.sourceforge.net/project/sox/sox/14.3.2/sox-14.3.2.tar.gz'
  homepage 'http://sox.sourceforge.net/'
  md5 'e9d35cf3b0f8878596e0b7c49f9e8302'

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis' => :optional
  depends_on 'flac' => :optional
  depends_on 'libao' => :optional
  depends_on 'mad' # see commit message

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gomp"
    system "make install"
  end
end

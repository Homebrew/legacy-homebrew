require 'formula'

class Sox < Formula
  homepage 'http://sox.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sox/sox/14.4.0/sox-14.4.0.tar.gz'
  md5 'b0c15cff7a4ba0ec17fdc74e6a1f9cf1'

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis' => :optional
  depends_on 'flac' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'libao' => :optional
  depends_on 'mad'

  def install
    ENV.x11  # For libpng, used for the optional "spectrogram" effect.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gomp"
    system "make install"
  end
end

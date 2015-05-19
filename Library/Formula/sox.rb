require 'formula'

class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage 'http://sox.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz'
  sha1 'f69f38f8a7ad6a88ecab3862d74db4edcd796695'

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

require 'brewkit'

class Id3lib <Formula
  @url='http://voxel.dl.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz'
  @homepage='http://id3lib.sourceforge.net/'
  @md5='19f27ddd2dda4b2d26a559a4f0f402a7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

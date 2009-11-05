require 'formula'

class Mhash <Formula
  @url='http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz'
  @homepage='http://mhash.sourceforge.net/'
  @md5='f91c74f9ccab2b574a98be5bc31eb280'

  def install
    system "./configure --prefix=#{prefix} --disable-debug --disable-dependency-tracking"
    system "make install"
  end
end

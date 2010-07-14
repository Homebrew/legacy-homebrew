require 'formula'

class Mhash <Formula
  @url='http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz'
  @homepage='http://mhash.sourceforge.net/'
  @md5='ee66b7d5947deb760aeff3f028e27d25'

  def install
    system "./configure --prefix=#{prefix} --disable-debug --disable-dependency-tracking"
    system "make install"
  end
end

require 'formula'

class Raptor <Formula
  url 'http://download.librdf.org/source/raptor-1.4.21.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '992061488af7a9e2d933df6b694bb876'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

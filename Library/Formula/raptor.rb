require 'formula'

class Raptor <Formula
  url 'http://download.librdf.org/source/raptor-2.0.0.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '0d4a53b3f8f661b604e3bed20ae00e6c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

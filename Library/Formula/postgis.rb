require 'brewkit'

class Postgis <Formula
  url 'http://postgis.refractions.net/download/postgis-1.4.0.tar.gz'
  homepage 'http://postgis.refractions.net/'
  md5 'bc5b97d5399bd20ca90bfdf784ab6c33'

  depends_on 'postgresql'
  depends_on 'proj'
  depends_on 'geos'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

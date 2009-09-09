require 'brewkit'

class Sphinx <Formula
  @url='http://www.sphinxsearch.com/downloads/sphinx-0.9.8.1.tar.gz'
  @homepage='http://www.sphinxsearch.com'
  @md5='428a14df41fb425e664d9e2d6178c037'

  def deps
    'mysql'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

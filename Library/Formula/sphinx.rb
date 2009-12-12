require 'formula'

class Sphinx <Formula
  version '0.9.9'
  @url='http://www.sphinxsearch.com/downloads/sphinx-0.9.9.tar.gz'
  @homepage='http://www.sphinxsearch.com'
  @md5='7b9b618cb9b378f949bb1b91ddcc4f54'

  depends_on 'mysql'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

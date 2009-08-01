require 'brewkit'

class Python <Formula
  @url='http://www.python.org/ftp/python/2.6.2/Python-2.6.2.tar.bz2'
  @homepage='http://www.python.org/'
  @md5='245db9f1e0f09ab7e0faaa0cf7301011'

  def deps
    # You can build Python without readline, but you really don't want to.
    LibraryDep.new 'readline'
  end

  def install
    # Todo: Link against custom readline
    system "./configure --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end

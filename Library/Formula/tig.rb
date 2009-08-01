require 'brewkit'

class Tig <Formula
  @url='http://jonas.nitro.dk/tig/releases/tig-0.14.1.tar.gz'
  @homepage='http://jonas.nitro.dk/tig/'
  @md5='e47bf48813c0cbe6be0f3b749e6de96c'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end
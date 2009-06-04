require 'brewkit'

class Mad <Formula
  @homepage='http://www.underbit.com/products/mad/'
  @url='http://kent.dl.sourceforge.net/sourceforge/mad/libmad-0.15.1b.tar.gz'
  @md5='1be543bc30c56fb6bea1d7bf6a64e66c'

  def install
    system "./configure --disable-debugging --enable-fpm=intel --prefix='#{prefix}'"
    system "make install"
  end
end
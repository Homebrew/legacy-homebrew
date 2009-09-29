require 'brewkit'

class Guile <Formula
  @url='ftp://alpha.gnu.org/gnu/guile/guile-1.9.3.tar.gz'
  @homepage='http://www.gnu.org/software/guile/'
  @sha1='c8d1d25ed413b48493ec5b0cbf4de8593cab4a21'

  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'
  
  # GNU Readline is required
  # libedit won't work.
  depends_on 'readline'

  def install
    system "./configure",
        "--prefix=#{prefix}", 
        "--disable-debug", 
        "--disable-dependency-tracking",
        # Specifically look for readline here
        # At least, we don't want the fake readline in
        # /usr/lib to trump us, since it doesn't export
        # all the same symbols
        # --adamv
        "--with-libreadline-prefix=#{Formula.factory('readline').prefix}"
    system "make install"
  end
end
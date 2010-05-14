require 'formula'

class Guile <Formula
  @url='ftp://alpha.gnu.org/gnu/guile/guile-1.9.3.tar.gz'
  @homepage='http://www.gnu.org/software/guile/'
  @sha1='c8d1d25ed413b48493ec5b0cbf4de8593cab4a21'

  depends_on 'pkg-config'
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'
  
  # GNU Readline is required; libedit won't work.
  depends_on 'readline'

  def install
    system "./configure",
        "--prefix=#{prefix}", 
        "--disable-debug", 
        "--disable-dependency-tracking",
        "--with-libreadline-prefix=#{Formula.factory('readline').prefix}"
    system "make install"
  end
end
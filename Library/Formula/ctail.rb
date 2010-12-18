require 'formula'

class Ctail <Formula
  url 'http://ctail.i-want-a-pony.com/downloads/ctail-0.1.0.tar.bz2'
  homepage 'http://ctail.i-want-a-pony.com/'
  md5 'fc39139aeaf3400aa13b338e2266b976'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "/usr/share/apr-1/build-1/libtool --silent --mode=compile gcc -g -Wall -Werror -DDARWIN -DSIGPROCMASK_SETS_THREAD_MASK -I. -I/usr/include/apr-1 -I/usr/include/apr-1  -c -o ctail.lo ctail.c && touch ctail.lo"
    system "/usr/share/apr-1/build-1/libtool --silent --mode=link gcc -o ctail ctail.lo -L/usr/lib -R/usr/lib -laprutil-1 -lexpat -liconv -lsqlite3 -L/usr/lib -R/usr/lib -lapr-1 -lpthread"
    bin.mkpath
    system "/usr/share/apr-1/build-1/libtool --silent --mode=install /usr/bin/install -c -m 755 ctail #{bin}"
  end
end

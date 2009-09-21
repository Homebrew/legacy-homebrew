require 'brewkit'

class Python <Formula
  @url='http://www.python.org/ftp/python/2.6.2/Python-2.6.2.tar.bz2'
  @homepage='http://www.python.org/'
  @md5='245db9f1e0f09ab7e0faaa0cf7301011'

  # You can build Python without readline, but you really don't want to.
  depends_on 'readline' => :recommended

  def skip_clean? path
    path == bin+'python' or path == bin+'python2.6' or # if you strip these, it can't load modules
    path == lib+'python2.6' # save a lot of time
  end

  def install
    system "./configure --prefix='#{prefix}' --with-framework-name=/Developer/SDKs/MacOSX10.5.sdk"
    system "make"
    system "make install"
    
    # lib/python2.6/config contains a copy of libpython.a; make this a link instead
    (lib+'python2.6/config/libpython2.6.a').unlink
    (lib+'python2.6/config/libpython2.6.a').make_link lib+'libpython2.6.a'
  end
end

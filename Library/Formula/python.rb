require 'formula'

class Python <Formula
  url 'http://python.org/ftp/python/2.6.4/Python-2.6.4.tar.bz2'
  homepage 'http://www.python.org/'
  md5 'fee5408634a54e721a93531aba37f8c1'

  # You can build Python without readline, but you really don't want to.
  depends_on 'readline' => :recommended
  
  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--intel", "Build for both 32 & 64 bit Intel."]
    ]
  end

  def skip_clean? path
    path == bin+'python' or path == bin+'python2.6' or # if you strip these, it can't load modules
    path == lib+'python2.6' # save a lot of time
  end

  def install
    args = ["--prefix=#{prefix}"]

    if ARGV.include? '--framework'
      args << "--enable-framework"
    end
    
    if ARGV.include? '--intel'
      args << "--with-universal-archs=intel --enable-universalsdk=/"
    end
    
    # Speed up creation of libpython.a, backported from Unladen Swallow:
    # http://code.google.com/p/unladen-swallow/source/detail?r=856
    inreplace "Makefile.pre.in", "$(AR) cr", "$(AR) cqS"
    
    system "./configure", *args
    
    
    system "make"
    system "make install"
    
    # lib/python2.6/config contains a copy of libpython.a; make this a link instead
    (lib+'python2.6/config/libpython2.6.a').unlink
    (lib+'python2.6/config/libpython2.6.a').make_link lib+'libpython2.6.a'
  end
end

require 'formula'

class Python <Formula
  url 'http://python.org/ftp/python/2.6.4/Python-2.6.4.tar.bz2'
  homepage 'http://www.python.org/'
  md5 'fee5408634a54e721a93531aba37f8c1'

  # You can build Python 2.6.4 without GNU readline, but you really don't want to.
  depends_on 'readline' => :recommended
  # http://docs.python.org/library/gdbm.html
  depends_on 'gdbm' => :optional
  # http://docs.python.org/library/sqlite3.html
  depends_on 'sqlite' => :optional

  def patches
    # don't append space after completion
    {:p0 => ["http://bugs.python.org/file14599/python-2.6-readline.patch"]}
  end
  
  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--universal", "Build for both 32 & 64 bit Intel."]
    ]
  end

  def skip_clean? path
    path == bin+'python' or path == bin+'python2.6' or # if you strip these, it can't load modules
    path == lib+'python2.6' # save a lot of time
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-framework" if ARGV.include? '--framework'
    
    # Note --intel is an old flag, supported here for back compat. but not documented in options.
    if ARGV.include? '--universal' or ARGV.include? '--intel'
      args << "--with-universal-archs=intel" << "--enable-universalsdk=/" << "--enable-universal-archs=all"
    end
    
    # Speed up creation of libpython.a, backported from Unladen Swallow:
    # http://code.google.com/p/unladen-swallow/source/detail?r=856
    inreplace "Makefile.pre.in", "$(AR) cr", "$(AR) cqS"
    
    system "./configure", *args
    system "make"
    system "make install"
  end
end

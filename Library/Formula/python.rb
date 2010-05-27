require 'formula'

class Python <Formula
  url 'http://www.python.org/ftp/python/2.6.5/Python-2.6.5.tar.bz2'
  homepage 'http://www.python.org/'
  md5 '6bef0417e71a1a1737ccf5750420fdb3'

  # Python 2.6.5 will build against OS X's libedit,
  # but let's keep using GNU readline.
  depends_on 'readline' => :optional
  # http://docs.python.org/library/gdbm.html
  depends_on 'gdbm' => :optional
  # http://docs.python.org/library/sqlite3.html
  depends_on 'sqlite' => :optional

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
    
    # Note --intel is an old flag, supported here for back compat.
    if ARGV.include? '--universal' or ARGV.include? '--intel'
      args.push "--enable-universalsdk=/", "--with-universal-archs=intel"
    end
    
    # Speed up creation of libpython.a, backported from Unladen Swallow:
    # http://code.google.com/p/unladen-swallow/source/detail?r=856
    inreplace "Makefile.pre.in", "$(AR) cr", "$(AR) cqS"
    
    system "./configure", *args
    system "make"
    ENV.j1 # Framework builds need to be installed serialized
    system "make install"
  end
end

require 'brewkit'

# TODO de-version the include and lib directories

class Ruby <Formula
  @url='ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p174.tar.gz'
  @homepage='http://www.ruby-lang.org/en/'
  @md5='18dcdfef761a745ac7da45b61776afa5'
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-pthread",
                          "CFLAGS=-D_XOPEN_SOURCE=1"
    system "make"
    system "make install"
  end
  
  def skip_clean? path
    # TODO only skip the clean for the files that need it, we didn't even get
    # a comment about why we're skipping the clean, so you'll need to figure
    # that out too --mxcl
    true
  end
end

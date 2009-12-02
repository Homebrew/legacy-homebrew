require 'formula'

# TODO de-version the include and lib directories

class Ruby <Formula
  @url='ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
  @homepage='http://www.ruby-lang.org/en/'
  @md5='515bfd965814e718c0943abf3dde5494'

  depends_on 'readline'
  
  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared"
    system "make"
    system "make install"
  end
  
  def skip_clean? path
    # TODO only skip the clean for the files that need it, we didn't get a
    # comment about why we're skipping the clean, so you'll need to figure
    # that out first --mxcl
    true
  end
end

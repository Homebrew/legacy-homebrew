require 'brewkit'

# TODO deversion the include and lib directories

class Ruby <Formula
  @url='ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
  @homepage='http://www.ruby-lang.org'
  @md5='515bfd965814e718c0943abf3dde5494'

  def install
    system "./configure", "--prefix=#{prefix}"
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

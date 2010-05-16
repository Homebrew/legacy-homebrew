require 'formula'

# TODO de-version the include and lib directories

class Ruby <Formula
  @url='http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p378.tar.gz'
  @homepage='http://www.ruby-lang.org/en/'
  @md5='9fc5941bda150ac0a33b299e1e53654c'

  depends_on 'readline'
  
  def options
    [
      ["--with-suffix", "Add a 19 suffix to commands"],
      ["--with-doc", "Install with the Ruby documentation"],
    ]
  end
  
  def install
    ENV.gcc_4_2

    args = [ "--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--enable-shared" ]

    args << "--program-suffix=19" if ARGV.include? "--with-suffix"

    system "./configure", *args
    system "make"
    system "make install"

    system "make install-doc" if ARGV.include? "--with-doc"
  end
  
  def caveats; <<-EOS
If you install gems with the RubyGems installed with this formula they will
be installed to this formula's prefix. This needs to be fixed, as for example,
upgrading Ruby will lose all your gems.
    EOS
  end
  
  def skip_clean? path
    # TODO only skip the clean for the files that need it, we didn't get a
    # comment about why we're skipping the clean, so you'll need to figure
    # that out first --mxcl
    true
  end
end

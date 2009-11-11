require 'formula'

class Ruby <Formula
  url 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
  homepage 'http://www.ruby-lang.org/en/'
  md5 '515bfd965814e718c0943abf3dde5494'

  depends_on 'readline'
  skip_clean 'bin/ruby'
  
  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared"
    system "make"
    system "make install"

    unless ARGV.include? '--enable-super-dupe'
      Dir.chdir prefix
      FileUtils.rm_rf Dir['lib/ruby/*/rubygems']
      FileUtils.rm_rf Dir['lib/ruby/*/rake']
      File.unlink 'bin/gem'
      File.unlink 'bin/rake'
      File.unlink man1+'rake.1'
    end
  end
  
  def caveats; <<-EOS
By default we don't install the bundled Rake or RubyGems.

This is because they both come with the system installed Ruby. You can upgrade
them with `gem update --system`.

If you really want them though do:

    brew install ruby --force --enable-super-dupe

If you disagree with this decision, please create an issue on GitHub as we 
should discuss the matter.
    EOS
  end
end

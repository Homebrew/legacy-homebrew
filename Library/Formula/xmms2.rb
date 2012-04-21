require 'formula'

class Xmms2 < Formula
  homepage 'http://xmms2.org/wiki/Main_Page'
  url 'http://sourceforge.net/projects/xmms2/files/xmms2/0.8%20DrO_o/xmms2-0.8DrO_o.tar.bz2'
  mirror 'http://en.sourceforge.jp/frs/g_redir.php?m=jaist&f=%2Fxmms2%2Fxmms2%2F0.8+DrO_o%2Fxmms2-0.8DrO_o.tar.bz2'
  sha1 '9f7585571d95acd98df48c37948e8638fae7cc3a'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'sqlite'
  #Xform plugins
  depends_on 'mad'
  depends_on 'faad2'
  depends_on 'libvorbis'
  depends_on 'flac'
  depends_on 'musepack'
  depends_on 'libmms'
  depends_on 'ffmpeg'
  depends_on 'fftw'
  depends_on 'libxml2'
  depends_on 'mpg123'
  depends_on 'wavpack'
  depends_on 'libcdio'
  depends_on 'sc68'
  #Output plugins
  depends_on 'jack' if build.include? "enable-jack"
  depends_on 'libao'
  depends_on 'libshout'
  #Language bindings
  depends_on 'boost'

  fails_with :clang do
    build 318
    cause 'error: binding of reference to type...'
  end

  #binaries fail with Symbol not found errors.
  skip_clean 'bin'

  option 'enable-jack', "Enable JACK output."

  def install
    args = [
       "--prefix=#{prefix}",
       "--conf-prefix=#{prefix}",
       "--with-perl-archdir=#{HOMEBREW_PREFIX}/lib/perl5/site_perl",
       "--with-ruby-archdir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby",
       "--with-ruby-libdir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby"
    ]
    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  def caveats; <<-EOS.undent
      The Perl bindings won't function until you amend your PERL5LIB like so:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:$PERL5LIB

      You may need to add the Ruby bindings to your RUBYLIB from:
      export RUBYLIB=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby:$RUBYLIB

      For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      If you install Python packages via "pip install x" or "python setup.py install"
      (or the outdated easy_install), any provided scripts will go into the
        #{HOMEBREW_PREFIX}/share/python, so you may want to add it to your PATH.

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python for more info.
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

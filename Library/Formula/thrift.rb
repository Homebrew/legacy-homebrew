require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.8.0/thrift-0.8.0.tar.gz'
  md5 'd29dfcd38d476cbc420b6f4d80ab966c'

  head 'http://svn.apache.org/repos/asf/thrift/trunk'

  depends_on 'boost'

  def install
    # No reason for this step is known. On Lion at least the pkg.m4 doesn't
    # even exist. Turns out that it isn't needed on Lion either. Possibly it
    # isn't needed anymore at all but I can't test that.
    cp "#{MacOS.x11_prefix}/share/aclocal/pkg.m4", "aclocal" if MACOS_VERSION < 10.7

    system "./bootstrap.sh" if ARGV.build_head?

    # Language bindings try to install outside of Homebrew's prefix, so
    # omit them here. For ruby you can install the gem, and for Python
    # you can use pip or easy_install.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--without-haskell",
                          "--without-java",
                          "--without-python",
                          "--without-ruby",
                          "--without-perl",
                          "--without-php",
                          "--without-erlang"
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Most language bindings were not installed. You may like to do the
    following:

        gem install thrift
        easy_install thrift

    If anyone figures out the steps to reliably build a set of bindings, please
    open a pull request.
    EOS
  end
end

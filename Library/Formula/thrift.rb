require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.8.0/thrift-0.8.0.tar.gz'
  sha1 '1d652d7078d9cc70e2a45d3119b13e86ebd446da'

  head 'http://svn.apache.org/repos/asf/thrift/trunk'

  depends_on 'boost'

  def install
    # No reason for this step is known. On Lion at least the pkg.m4 doesn't
    # even exist. Turns out that it isn't needed on Lion either. Possibly it
    # isn't needed anymore at all but I can't test that.
<<<<<<< HEAD
    cp "#{MacOS::XQuartz.share}/aclocal/pkg.m4", "aclocal" if MACOS_VERSION < 10.7
=======
    cp "#{MacOS::X11.share}/aclocal/pkg.m4", "aclocal" if MACOS_VERSION < 10.7
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

    system "./bootstrap.sh" if build.head?

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

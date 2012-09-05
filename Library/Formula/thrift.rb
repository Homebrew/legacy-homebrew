require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.8.0/thrift-0.8.0.tar.gz'
  sha1 '1d652d7078d9cc70e2a45d3119b13e86ebd446da'

  head 'http://svn.apache.org/repos/asf/thrift/trunk'

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on 'boost'

  def install
    # No reason for this step is known. On Lion at least the pkg.m4 doesn't
    # even exist. Turns out that it isn't needed on Lion either. Possibly it
    # isn't needed anymore at all but I can't test that.
    cp "#{MacOS::X11.share}/aclocal/pkg.m4", "aclocal" if MacOS.version < :lion

    system "./bootstrap.sh" if build.head?

    exclusions = ["--without-python", "--without-ruby"]

    exclusions << "--without-haskell" unless build.include? "with-haskell"
    exclusions << "--without-java" unless build.include? "with-java"
    exclusions << "--without-perl" unless build.include? "with-perl"
    exclusions << "--without-php" unless build.include? "with-php"
    exclusions << "--without-erlang" unless build.include? "with-erlang"

    # Language bindings try to install outside of Homebrew's prefix, so
    # omit them here. For ruby you can install the gem, and for Python
    # you can use pip or easy_install.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
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

require 'formula'

class Thrift050Finagle < Formula
  homepage 'https://github.com/mariusaeriksen/thrift-0.5.0-finagle'
  url 'https://github.com/mariusaeriksen/thrift-0.5.0-finagle/tarball/master'
  version '0.5.0'
  md5 'c06945fd690085291a1a08f3b815be99'

  depends_on 'boost'

  def install
    # No reason for this step is known. On Lion at least the pkg.m4 doesn't
    # even exist. Turns out that it isn't needed on Lion either. Possibly it
    # isn't needed anymore at all but I can't test that.
    cp "/usr/X11/share/aclocal/pkg.m4", "aclocal" if MACOS_VERSION < 10.7

    system "./bootstrap.sh" if version == 'HEAD'

    # Language bindings try to install outside of Homebrew's prefix, so
    # omit them here. For ruby you can install the gem, and for Python
    # you can use pip or easy_install.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--without-haskell",
                          "--without-python",
                          "--without-ruby",
                          "--without-perl",
                          "--without-php",
                          "--without-php_extension",
                          "--without-erlang",
                          "--without-cshrap"
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

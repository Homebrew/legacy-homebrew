require 'formula'

class Thrift < Formula
  homepage 'http://incubator.apache.org/thrift/'
  head 'http://svn.apache.org/repos/asf/thrift/trunk'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.6.1/thrift-0.6.1.tar.gz'
  md5 'e1ec722d5f38077a23a32c4de4d4ce94'

  depends_on 'boost'

  def install
    cp "/usr/X11/share/aclocal/pkg.m4", "aclocal"
    system "./bootstrap.sh" if version == 'HEAD'

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
                          "--without-php"
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Some bindings were not installed. You may like to do the following:

        gem install thrift
        easy_install thrift

    Perl and PHP bindings are a mystery someone should solve.
    EOS
  end
end

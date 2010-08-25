require 'formula'

class Thrift <Formula
  homepage 'http://incubator.apache.org/thrift/'
  head 'http://svn.apache.org/repos/asf/incubator/thrift/trunk'
  version '0.3.0'
  url 'http://www.apache.org/dist/incubator/thrift/0.3.0-incubating/thrift-0.3.0.tar.gz'
  md5 'a6c80ab3d8c7827365a9b40f5c9d66a3'

  depends_on 'boost'

  def install
    cp "/usr/X11/share/aclocal/pkg.m4", "aclocal"
    system "./bootstrap.sh" if version == 'HEAD'
    system "./configure","--disable-debug","--without-java",
                         "--prefix=#{prefix}","--libdir=#{lib}",
                         # rationale: this can be installed with easy_install
                         # and when you do that, it installs properly, we
                         # can't install it properly without leaving Homebrew's prefix
                         "--without-py",
                         # again, use gem
                         "--without-ruby",
                         "--without-perl",
                         # this wants to alter the system wide autoloads file
                         "--without-php"
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

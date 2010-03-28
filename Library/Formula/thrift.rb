require 'formula'

# TODO Fix java support anyone?
#
#

class Thrift <Formula
  homepage 'http://incubator.apache.org/thrift/'
  head 'http://svn.apache.org/repos/asf/incubator/thrift/trunk'
  version '0.2.0'
  url 'http://apache.dataphone.se/incubator/thrift/0.2.0-incubating/thrift-0.2.0-incubating.tar.gz'
  md5 '9958c57c402c02171ba0bcc96183505c'

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
                         "--without-perl"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Some bindings were not installed. You may like to do the following:

        gem install thrift
        easy_install thrift

    Perl bindings are a mystery someone should solve.
    EOS
  end
end

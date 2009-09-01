require 'brewkit'

# TODO Fix java support anyone?
#
#

class Thrift <Formula
  @homepage='http://incubator.apache.org/thrift/'
  @head='http://svn.apache.org/repos/asf/incubator/thrift/trunk'

  def install
    FileUtils.cp "/usr/X11/share/aclocal/pkg.m4", "aclocal"
    system "./bootstrap.sh"
    system "./configure","--disable-debug","--without-java",
                         "--prefix=#{prefix}","--libdir=#{lib}",
                         # rationale: this can be installed with easy_install
                         # and when you do that, it installs properly, we
                         # can't install it properly without leaving Homebrew's prefix
                         "--without-py"
    system "make"
    system "make install"
  end
  
  def caveats; <<-EOS
We didn't install the python bindings, to do that:

    easy_install thrift
    EOS
  end
end

require 'formula'

class Thrift < Formula
  homepage 'http://incubator.apache.org/thrift/'
  head 'http://svn.apache.org/repos/asf/thrift/trunk'
  url 'http://www.apache.org/dyn/closer.cgi?path=thrift/0.7.0/thrift-0.7.0.tar.gz'
  md5 '7a57a480745eab3dd25e02f5d5cc3770'
  # Mac OS X Lion doesn't have pkg.m4, copy it from pkg-config, so depends on it.
  depends_on 'pkg-config' => :build if MacOS.lion?
  depends_on 'boost'

  def install
    # Mac OS X Lion doesn't have pkg.m4, copy it from pkg-config.
    # Copy it from X11 on systems other than Lion.
    pkg_config_path = MacOS.lion? ? Formula.factory("pkg-config").installed_prefix : "/usr/X11"
    cp "#{pkg_config_path}/share/aclocal/pkg.m4", "aclocal"
    system "./bootstrap.sh" if version == 'HEAD'
    # Make those scripts executable.
    system "chmod +x configure"
    system "chmod +x install-sh"
    system "chmod +x lib/erl/rebar"
    # Language bindings try to install outside of Homebrew's prefix, so
    # omit them here. For ruby you can install the gem, and for Python
    # you can use pip or easy_install.
    # Installing Java binding because it's commonly used.
    ENV["JAVA_PREFIX"] = "#{lib}/java"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--without-haskell",
                          "--without-ruby",
                          "--without-python",
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
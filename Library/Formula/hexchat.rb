require 'formula'

class Hexchat < Formula
  homepage 'http://hexchat.github.io/'
  head 'https://github.com/hexchat/hexchat.git'

  stable do
    url 'http://dl.hexchat.net/hexchat/hexchat-2.10.0.tar.xz'
    sha256 'a0247f1e12379154d0719d9c6861dc22817b588562653bb9d3626863d8eca916'

    patch do
      # Fixes building --with-plugin on older than Mavericks and --without-plugin on all
      url 'https://github.com/hexchat/hexchat/commit/8578a9d52d993f4425259462c01854ea7784c57f.diff'
      sha256 '77575dc70943299422d87c9d5b57061f49aa7bd58c03fbd78973e37a8310c625'
    end
  end

  depends_on :macos => :lion

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build
  depends_on 'intltool' => :build
  depends_on 'gnome-common' => :build
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on :x11

  option 'without-perl', 'Build without Perl support'
  option 'without-plugins', 'Build without plugin support'

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-openssl]

    if build.with? "python3"
      py_ver = Formula["python3"].version.to_s[0..2] # e.g "3.4"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/Frameworks/Python.framework/Versions/#{py_ver}/lib/pkgconfig/"
      args << "--enable-python=python#{py_ver}"
    elsif build.with? "python"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig/"
      ENV.append_path "PKG_CONFIG_PATH", "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig/"
      args << "--enable-python=python2.7"
    else
      args << "--disable-python"
    end

    args << "--disable-perl" if build.without? "perl"
    args << "--disable-plugin" if build.without? "plugins"

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make install"

    rm_rf share/"applications"
    rm_rf share/"appdata"
  end
end

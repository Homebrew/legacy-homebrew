require 'formula'

class Hexchat < Formula
  homepage 'http://hexchat.github.io/'
  head 'https://github.com/hexchat/hexchat.git'
  url 'http://dl.hexchat.net/hexchat/hexchat-2.10.1.tar.xz'
  sha1 '3ad562ec76323ba9d0f279d36201a333594c755b'

  bottle do
    sha1 "da41ccf19d762513a1e774c078a2f7bf9e46073c" => :mavericks
    sha1 "f10e3860adee826c03e6269991a5e77d884be028" => :mountain_lion
    sha1 "728caab194af26da2f6eec798fb162dffa817698" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
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

    system "./configure", *args
    system "make", "install"

    rm_rf share/"applications"
    rm_rf share/"appdata"
  end
end

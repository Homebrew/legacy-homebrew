require 'formula'

class Hexchat < Formula
  homepage 'http://hexchat.github.io/'
  url 'http://dl.hexchat.net/hexchat/hexchat-2.9.6.1.tar.xz'
  sha1 'a2978606df331117440614cce188494f97ebed31'

  head do
    url 'https://github.com/hexchat/hexchat.git'
    depends_on 'intltool' => :build
    depends_on 'gnome-common' => :build
  end

  depends_on :macos => :lion

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build
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
      py_ver = Formula["python3"].pkg_version.to_s[0..2] # e.g "3.4"
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

    # > 2.9.6.1 has these issues fixed
    if not build.head?
      args << "--disable-xlib"

      # Fails on 32-bit core solo without this
      args << "--disable-mmx" unless MacOS.prefer_64_bit?

      # Build fails because of a conflict with the system 'strptime',
      # so rename the function
      inreplace "src/fe-gtk/banlist.c" do |s|
        s.gsub! "strptime", "_strptime"
      end

      # The locations of the gettext dependencies are hardcoded, so copy them
      gettext = Formula["gettext"].opt_prefix/"share/gettext"
      cp_r ["#{gettext}/intl", "#{gettext}/po"], "."
    end

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf -vi"
    end
    system "./configure", *args
    system "make"
    system "make install"

    rm_rf share/"applications"
    rm_rf share/"appdata"
  end
end

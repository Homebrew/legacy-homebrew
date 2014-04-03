require 'formula'

class Rtorrent < Formula
  homepage 'http://libtorrent.rakshasa.no/'
  url 'http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.3.tar.gz'
  sha256 '9e93ca41beb1afe74ad7ad8013e0d53ae3586c9b0e97263d722f721535cc7310'

  depends_on 'pkg-config' => :build
  depends_on 'libtorrent'
  depends_on 'xmlrpc-c' => :optional

  # rtorrent gets a private libsigc++ because libtorrent can only build
  # under libstdc++, but libsigc++ is too widely used for us to force it
  # to use libstdc++ globally.
  # This should be removed once libtorrent is fixed to work under libstdc++.
  # See https://github.com/mxcl/homebrew/issues/23483
  resource 'libsigcxx' do
    url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.3/libsigc++-2.3.1.tar.xz'
    sha256 '67d05852b31fdb267c9fdcecd40b046a11aa54d884435e99e3c60dd20cd60393'
  end

  def install
    ENV.libstdcxx if ENV.compiler == :clang

    resource('libsigcxx').stage do
      system "./configure", "--prefix=#{libexec}/libsigcxx", "--disable-dependency-tracking"
      system "make"
      system "make check"
      system "make install"
    end

    # Skip pkg-config, which was having trouble looking into rtorrent's libexec
    ENV['sigc_CFLAGS'] = "-I#{libexec}/libsigcxx/include/sigc++-2.0 \
      -I#{libexec}/libsigcxx/lib/sigc++-2.0/include"
    ENV['sigc_LIBS'] = "-L#{libexec}/libsigcxx/lib -lsigc-2.0"

    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-xmlrpc-c" if build.with? "xmlrpc-c"
    if MacOS.version <= :leopard
      inreplace 'configure' do |s|
        s.gsub! '  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs "libcurl >= 7.15.4" 2>/dev/null`',
          '  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs "libcurl >= 7.15.4" | sed -e "s/-arch [^-]*/-arch $(uname -m) /" 2>/dev/null`'
      end
    end
    system "./configure", *args
    system "make"
    system "make install"
  end
end

require 'formula'

class Nspr < Formula
  homepage 'http://www.mozilla.org/projects/nspr/'
  url 'https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10/src/nspr-4.10.tar.gz'
  sha256 '0cfbe561676b92e5af3ddc7ac77452014e3da8885da66baec811e7354138cc16'

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: http://openradar.appspot.com/7209349
      target_frameworks = (Hardware.is_32_bit? or MacOS.version <= :leopard) ? "-framework Carbon" : ""
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", target_frameworks

      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --enable-pthreads
        --enable-ipv6
      ]
      args << "--enable-64bit" if MacOS.prefer_64_bit?
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make install"
    end
  end
end

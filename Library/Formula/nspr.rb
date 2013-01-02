require 'formula'

class Nspr < Formula
  homepage 'http://www.mozilla.org/projects/nspr/'
  url 'https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.9.3/src/nspr-4.9.3.tar.gz'
  sha256 '9ca3f30b5ae6784f9820b32939284a7f14f67230a916c5752acd8ddace72f3c5'

  def install
    ENV.deparallelize
    cd "mozilla/nsprpub" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: http://openradar.appspot.com/7209349
      target_frameworks = (Hardware.is_32_bit? or MacOS.version == :leopard) ? "-framework Carbon" : ""
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

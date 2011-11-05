require 'formula'

class Nspr < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.8.8/src/nspr-4.8.8.tar.gz'
  homepage 'http://www.mozilla.org/projects/nspr/'
  sha256 '92f3f4ded2ee313e396c180d5445cc3c718ff347d86c06b7bf14a1b5e049d4c9'

  def install
    ENV.deparallelize
    Dir.chdir "mozilla/nsprpub" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: http://openradar.appspot.com/7209349
      target_frameworks = (Hardware.is_32_bit? or MacOS.leopard?) ? "-framework Carbon" : ""
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", target_frameworks

      args = ["--prefix=#{prefix}", "--disable-debug", "--enable-strip", "--enable-optimize"]
      args << "--enable-64bit" if MacOS.prefer_64_bit?
      system "./configure", *args

      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make install"
    end
  end
end

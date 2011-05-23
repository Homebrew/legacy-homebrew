require 'formula'

class Nspr < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.8.6/src/nspr-4.8.6.tar.gz'
  homepage 'http://www.mozilla.org/projects/nspr/'
  md5 '592c275728c29d193fdba8009165990b'

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

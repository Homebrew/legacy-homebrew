require 'formula'

class Nspr < Formula
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.4/src/nspr-4.10.4.tar.gz"
  sha1 "43b2029d990515f952c89d2921397c064fbbe2e7"

  bottle do
    cellar :any
    sha1 "329f42e5f9b3110234770423792c0c87e18c4d53" => :mavericks
    sha1 "44a02dcd84912019fdc68398c4e23c1c303dac8b" => :mountain_lion
    sha1 "33050ee6f28f92be7d7c63a385827db3e0ae8712" => :lion
  end

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
        --enable-macos-target=#{MacOS.version}
      ]
      args << "--enable-64bit" if MacOS.prefer_64_bit?
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end
end

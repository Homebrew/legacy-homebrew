require 'formula'

class Nspr < Formula
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz"
  sha256 "507ea57c525c0c524dae4857a642b4ef5c9d795518754c7f83422d22fe544a15"

  bottle do
    cellar :any
    sha1 "1e87c42e16313409115c699f910351da3e36a225" => :yosemite
    sha1 "d6854a7c4c11207c1001af6cd71d148cd8c51313" => :mavericks
    sha1 "ceb1c3a8693af7726f5e9dceb3697dfcb9f616be" => :mountain_lion
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

require 'formula'

class Nspr < Formula
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.7/src/nspr-4.10.7.tar.gz"
  sha256 "389af5cfa863ea9bc6de7b30c15f8a4f9bddd8002f8c6fdc8b33caef43893938"

  bottle do
    cellar :any
    sha1 "0b5ae7b07ce671c57c590eb37807fb8391537284" => :yosemite
    sha1 "ac2f2904dd4c6e47fde68f3ac7c38a4745ec0702" => :mavericks
    sha1 "1180562bef675d27bf8b6d33da4e045927819538" => :mountain_lion
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

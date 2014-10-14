require 'formula'

class Nspr < Formula
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.6/src/nspr-4.10.6.tar.gz"
  sha1 "9f3f278f7f31574b2cdbb99d9703c58e51cd3e1c"

  bottle do
    cellar :any
    sha1 "defd1ff9cccc8b64599c22734757648d031dd2ec" => :mavericks
    sha1 "f72fbe6a2e2d45bc493faf9798060df4cc588a5e" => :mountain_lion
    sha1 "a09af6bd5def1c714bb68dc95909a2fd9019e861" => :lion
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

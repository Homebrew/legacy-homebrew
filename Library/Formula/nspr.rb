class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.9/src/nspr-4.10.9.tar.gz"
  sha256 "4112ff6ad91d32696ca0c6c3d4abef6367b5dc0127fa172fcb3c3ab81bb2d881"

  bottle do
    cellar :any
    sha256 "9860a936f88a0f57f05240e94daf678ddb8e014c0240e269da78f9207ef41b24" => :yosemite
    sha256 "e8ad4221a5a0a1769547f2c8bc6b45f57ae2591896ffde08e6d6ec2a6018fcf7" => :mavericks
    sha256 "ad1fb6a460c2f053cd9f6dce964a94354133b546caf7d9def37512c10f833a33" => :mountain_lion
  end

  keg_only <<-EOS.undent
    Having this library symlinked makes Firefox pick it up instead of built-in,
    so it then randomly crashes without meaningful explanation.

    Please see https://bugzilla.mozilla.org/show_bug.cgi?id=1142646 for details.
  EOS

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: http://openradar.appspot.com/7209349
      target_frameworks = (Hardware.is_32_bit? || MacOS.version <= :leopard) ? "-framework Carbon" : ""
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
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end
end

class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.11/src/nspr-4.11.tar.gz"
  sha256 "cb320a9eee7028275ac0fce7adc39dee36f14f02fd8432fce1b7e1aa5e3685c2"
  revision 1

  bottle do
    cellar :any
    sha256 "eff5dd947456737ffd3b6d4d23224d4c03b00161e8297c590bef8ca2558625da" => :el_capitan
    sha256 "f1caf728ad54fffbc335be659c4b7262b2180fd6bb6f4770cf3ec2255e02d633" => :yosemite
    sha256 "d56c87f6ea6ccc4efa65a1ba14e2fd67a6ab5ea51eedd6e89bb065954c1a28ee" => :mavericks
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
        --with-pthreads
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

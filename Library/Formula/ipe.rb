class Ipe < Formula
  desc "Drawing editor for creating figures in PDF or PS formats"
  homepage "http://ipe7.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ipe7/ipe/7.1/ipe-7.1.7-src.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/Ipe/ipe-7.1.7-src.tar.gz"
  sha256 "ec670cd7f0fa521271fc54bf9b663570d82280bdbe405be6de59535fec7c00d2"

  bottle do
    sha256 "f694eff81d650fb2777380b6a4038edca3db023dce2682a5a4f7a332aa5023ef" => :yosemite
    sha256 "321e713cf94d63297574e0bf9c20a331e11a35573e1e5c489d3516395a70e694" => :mavericks
    sha256 "7c9b0165eedc50fa04c7ab017ddeabbf43177c1b0098a212857b29412724a271" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "makeicns" => :build
  depends_on "lua"
  depends_on "qt"
  depends_on "cairo"
  depends_on "jpeg-turbo"
  depends_on "freetype"

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      IPE should be compiled with the same flags as Qt, which uses LLVM.
      ipeui_common.cpp:1: error: bad value (native) for -march= switch
    EOS
  end

  def install
    # There's a weird race condition around setting flags for Freetype
    # If we ever go back to using flags instead of pkg-config be wary of that.
    ENV.deparallelize

    cd "src" do
      # Ipe also build shared objects instead of dylibs. Boo.
      # https://sourceforge.net/p/ipe7/tickets/20
      # Will be fixed in next release, allegedly.
      inreplace "common.mak" do |s|
        s.gsub! ".so.$(IPEVERS)", ".$(IPEVERS).dylib"
        s.gsub! "lib$1.so", "lib$1.dylib"
        s.gsub! "ipelets/$1.so", "ipelets/$1.dylib"
      end

      # Comment this out so we can make use of pkg-config.
      # Upstream have said they will *never* support OS X, so we have free reign.
      inreplace "config.mak", "ifndef MACOS", "ifdef MACOS"
      system "make", "IPEPREFIX=#{HOMEBREW_PREFIX}"
      system "make", "IPEPREFIX=#{prefix}", "install"
    end
  end
end

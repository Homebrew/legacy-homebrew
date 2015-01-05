class Ipe < Formula
  homepage "http://ipe7.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ipe7/ipe/7.1/ipe-7.1.6-src.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/Ipe/ipe-7.1.6-src.tar.gz"
  sha1 "72fc2532cfa0a8591447dde3f60e5e4b2ecbf0d6"

  bottle do
    sha1 "53408fdfff0f17a6e60a6cc539ccf56b50c52168" => :yosemite
    sha1 "ade5a611e2a0afac642147acbdacbc47e3167b0a" => :mavericks
    sha1 "19d21ebd060dcdd4d6b37da15b93bbfa3dba4f79" => :mountain_lion
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

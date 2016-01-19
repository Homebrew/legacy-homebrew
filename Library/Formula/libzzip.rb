class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2"
  sha256 "a1b8033f1a1fd6385f4820b01ee32d8eca818409235d22caf5119e0078c7525b"

  bottle do
    cellar :any
    revision 2
    sha256 "f93a8fd68c8ed930f84f54f4f438191f4445d555f601b370b48c0fbeb2db0e56" => :el_capitan
    sha256 "ca2078a2a603b0d1c6fd81d01bb50ec0c82c15891b2549918ca058fd4d88f520" => :yosemite
    sha256 "84694b367a72ce8edb39976ab0b3f383c5dfffc1e58571e94e5d0d08ec190ed0" => :mavericks
  end

  option "with-sdl", "Enable SDL usage and create SDL_rwops_zzip.pc"
  option :universal

  deprecated_option "sdl" => "with-sdl"

  depends_on "pkg-config" => :build
  depends_on "sdl" => :optional

  conflicts_with "zzuf", :because => "both install `zzcat` binaries"

  def install
    if build.universal?
      ENV.universal_binary
      # See: https://sourceforge.net/p/zziplib/feature-requests/5/
      ENV["ac_cv_sizeof_long"] = "(LONG_BIT/8)"
    end

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-sdl" if build.with? "sdl"
    system "./configure", *args
    system "make", "install"
    ENV.deparallelize   # fails without this when a compressed file isn't ready
    system "make", "check" # runing this after install bypasses DYLD issues
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end

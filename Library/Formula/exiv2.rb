class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org"
  url "http://www.exiv2.org/exiv2-0.25.tar.gz"
  sha256 "c80bfc778a15fdb06f71265db2c3d49d8493c382e516cb99b8c9f9cbde36efa4"

  bottle do
    cellar :any
    sha256 "530145c8ab5017152cc084cec8f0b596ef9a19e27306795098a40111d69ffa65" => :el_capitan
    sha256 "8bb79b4e856fb907449e2f874174654d1d116e3db19356864ce864381dc58788" => :yosemite
    sha256 "b9e07c6c8b896698df0b52442894af8314f52878d468d1a348cd359c1afcb50f" => :mavericks
    sha256 "11669d8a844d23c5a99c0e0ff924347681b1c81b2c672ffa316654a7dd31d4e2" => :mountain_lion
  end

  head do
    url "svn://dev.exiv2.org/svn/trunk"
    depends_on "cmake" => :build
    depends_on "gettext" => :build
    depends_on "libssh"
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    if build.head?
      args = std_cmake_args
      args += %W[
        -DEXIV2_ENABLE_SHARED=ON
        -DEXIV2_ENABLE_XMP=ON
        -DEXIV2_ENABLE_LIBXMP=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_PNG=ON
        -DEXIV2_ENABLE_NLS=ON
        -DEXIV2_ENABLE_PRINTUCS2=ON
        -DEXIV2_ENABLE_LENSDATA=ON
        -DEXIV2_ENABLE_COMMERCIAL=OFF
        -DEXIV2_ENABLE_BUILD_SAMPLES=ON
        -DEXIV2_ENABLE_BUILD_PO=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_WEBREADY=ON
        -DEXIV2_ENABLE_CURL=ON
        -DEXIV2_ENABLE_SSH=ON
        -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/libssh.dylib
        -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
        ..
      ]
      mkdir "build.cmake" do
        system "cmake", "-G", "Unix Makefiles", ".", *args
        system "make", "install"
        # `-DCMAKE_INSTALL_MANDIR=#{man}` doesn't work
        mv prefix/"man", man
      end
    else
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end

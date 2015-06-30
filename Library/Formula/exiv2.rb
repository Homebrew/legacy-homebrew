class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org"
  url "http://www.exiv2.org/exiv2-0.25.tar.gz"
  sha256 "c80bfc778a15fdb06f71265db2c3d49d8493c382e516cb99b8c9f9cbde36efa4"

  bottle do
    cellar :any
    sha1 "2b40116bf2f81fc36df6c783923a52cc3b6bfabb" => :mavericks
    sha1 "b54795033eba76504c2d4f92b784976a5cb8b555" => :mountain_lion
    sha1 "57cfbff226fcb74cc152d0e70522092c0a894b05" => :lion
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

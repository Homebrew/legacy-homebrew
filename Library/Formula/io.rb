class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2013.12.04.tar.gz"
  sha256 "e31e8aded25069d945b55732960b3553ba69851a61bd8698b68dfca27b6724cd"

  head "https://github.com/stevedekorte/io.git"

  option "without-addons", "Build without addons"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  if build.with? "addons"
    depends_on "glib"
    depends_on "cairo"
    depends_on "gmp"
    depends_on "jpeg"
    depends_on "libevent"
    depends_on "libffi"
    depends_on "libogg"
    depends_on "libpng"
    depends_on "libsndfile"
    depends_on "libtiff"
    depends_on "libvorbis"
    depends_on "ossp-uuid"
    depends_on "pcre"
    depends_on "yajl"
    depends_on "xz"
    depends_on :python => :optional
  end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      make never completes. see:
      https://github.com/stevedekorte/io/issues/223
    EOS
  end

  # Fixes build on GCC with recursive inline functions;
  # committed upstream, will be in the next release.
  patch do
    url "https://github.com/stevedekorte/io/commit/f21a10ca0e8959e2a0774962c36392cf166be6a6.diff"
    sha256 "7dbea1f027de4a4b12decba13a3e58c3352cd599fae14054d7a3af5eb2c454bb"
  end

  def install
    ENV.j1

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    if build.without? "addons"
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  "#add_subdirectory(addons)"
    else
      inreplace "addons/CMakeLists.txt" do |s|
        if build.without? "python"
          s.gsub! "add_subdirectory(Python)", "#add_subdirectory(Python)"
        end

        # Turn off specific add-ons that are not currently working

        # Looks for deprecated Freetype header
        s.gsub! /(add_subdirectory\(Font\))/, '#\1'
        # Builds against older version of memcached library
        s.gsub! /(add_subdirectory\(Memcached\))/, '#\1'
      end
    end

    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make"
      output = `./_build/binaries/io ../libs/iovm/tests/correctness/run.io`
      if $?.exitstatus != 0
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system "make", "install"
    end
  end
end

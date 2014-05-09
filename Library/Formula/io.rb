require "formula"

class Io < Formula
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2013.12.04.tar.gz"
  sha1 "47d9a3e7a8e14c9fbe3b376e4967bb55f6c68aed"

  head "https://github.com/stevedekorte/io.git"

  option "without-addons", "Build without addons"

  depends_on "cmake" => :build
  depends_on :python => :recommended

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
  end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      make never completes. see:
      https://github.com/stevedekorte/io/issues/223
    EOS
  end

  def install
    ENV.j1
    if build.without? "addons"
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt",
        "add_subdirectory(addons)", '#add_subdirectory(addons)'
    else
      # Turn off specific add-ons that are not currently working
      inreplace "addons/CMakeLists.txt" do |addons|
        # Looks for deprecated Freetype header
        addons.gsub! /(add_subdirectory\(Font\))/, '#\1'
        # Builds against older version of memcached library
        addons.gsub! /(add_subdirectory\(Memcached\))/, '#\1'
      end
    end

    # Note, Python requires addons to be built
    if build.without? "python"
      inreplace "addons/CMakeLists.txt",
        "add_subdirectory(Python)", '#add_subdirectory(Python)'
    end

    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make"
      output = %x[./_build/binaries/io ../libs/iovm/tests/correctness/run.io]
      if $?.exitstatus != 0
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system "make install"
    end
  end
end

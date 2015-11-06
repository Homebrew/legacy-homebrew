class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"

  head "https://github.com/stevedekorte/io.git"

  stable do
    url "https://github.com/stevedekorte/io/archive/2013.12.04.tar.gz"
    sha256 "e31e8aded25069d945b55732960b3553ba69851a61bd8698b68dfca27b6724cd"

    # Upstream commit to fix the compilation on OS X
    patch do
      url "https://github.com/stevedekorte/io/commit/19fa63e8ca0473e2d2327bcd4690b5123b15e58f.patch"
      sha256 "30e4493a103b052b406634f7e431441c49d8c36788906de1944edc632ad71e9f"
    end

    # Fixes build on GCC with recursive inline functions;
    # committed upstream, will be in the next release.
    patch do
      url "https://github.com/stevedekorte/io/commit/f21a10ca0e8959e2a0774962c36392cf166be6a6.diff"
      sha256 "7dbea1f027de4a4b12decba13a3e58c3352cd599fae14054d7a3af5eb2c454bb"
    end
  end
  bottle do
    sha256 "a7d1dfa5a71c8416e649ede0489db258ad768303f42572df04472b4bb67fea93" => :el_capitan
    sha256 "2a399520d3969a2712f10a70527242df50353b413c0b911a59bdfb6bb1022059" => :yosemite
    sha256 "8d9af751dad080d7d58a36cc8eaa05922457d39baaefb288ada4b9653890d4b5" => :mavericks
  end


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
        s.gsub!(/(add_subdirectory\(Font\))/, '#\1')
        # Builds against older version of memcached library
        s.gsub!(/(add_subdirectory\(Memcached\))/, '#\1')
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

  test do
    (testpath/"test.io").write <<-EOS.undent
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end

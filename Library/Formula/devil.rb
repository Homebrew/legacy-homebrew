class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz"
    sha256 "682ffa3fc894686156337b8ce473c954bf3f4fb0f3ecac159c73db632d28a8fd"

    # fix compilation issue for ilur.c
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/3db2f9727cea4a51fbcfae742518c614020fb8f2/devil/patch-src-ILU-ilur-ilur.c.diff"
      sha256 "ce96bc4aad940b80bc918180d6948595ee72624ae925886b1b770f2a7be8a2f9"
    end
  end

  head do
    url "https://github.com/DentonW/DevIL.git"

    option "with-ilut", "Also build the ILUT library"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "homebrew/x11/freeglut" if build.with? "ilut"

    # fix compilation issue for ilur.c
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/3db2f9727cea4a51fbcfae742518c614020fb8f2/devil/patch-DevIL-src-ILU-ilur-ilur.c.diff"
      sha256 "8021ffcd5c9ea151b991c7cd29b49ecea14afdfe07cb04fa9d25ab07d836f7d0"
    end
  end

  bottle :disable, "Can't generate bottles until builds with either Clang or GCC-5"

  option :universal

  depends_on "libpng"
  depends_on "jpeg"

  # most compilation issues with clang are fixed in the following pull request
  # see https://github.com/DentonW/DevIL/pull/30
  # see https://sourceforge.net/p/openil/bugs/204/
  # also, even with -std=gnu99 removed from the configure script,
  # devil fails to build with clang++ while compiling il_exr.cpp
  fails_with :clang do
    cause "invalid -std=gnu99 flag while building C++"
  end

  # ./../src-IL/include/il_internal.h:230:54:
  #   error: expected ',' or '...' before 'FileName'
  # https://github.com/Homebrew/homebrew/issues/40442
  fails_with :gcc => "5"

  def install
    ENV.universal_binary if build.universal?

    if build.head?
      cd "DevIL/"
      system "./autogen.sh"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ILU
    ]
    args << "--enable-ILUT" if build.stable? || build.with?("ilut")

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <IL/devil_cpp_wrapper.hpp>
      int main() {
        ilImage image;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lIL", "-lILU", "-o", "test"
    system "./test"
  end
end

class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.23.0.tar.gz"
  sha256 "49d75c601eb619481ecc0a79f3356cc26b89dfa646f2268e434d7b4c8d90c8a1"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "6e7f170a509c9af7064a3f165b8bc4301aeb67e65b2a1c6b02f0dc64204aa7f7" => :el_capitan
    sha256 "2d25f1c36cdef7902c36192590244986d5bd0d0bbbef82084c07734b947416eb" => :yosemite
    sha256 "f7f74c93652fba0e228b814d15ea56c02024b79216050ad07c88e17e2fd63ecf" => :mavericks
    sha256 "c61ca3ddd7fcd6b861b9ac51963d32c7584c99ab863204365806fef4cf0bc6b5" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

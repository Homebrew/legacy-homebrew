class Libgig < Formula
  desc "library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-3.3.0.tar.bz2"
  sha256 "d22a3c7ba13d920c1d4b6c218107ad105622ae9d1236ffbce007b98547774425"

  bottle do
    cellar :any
    sha256 "3f669e4d7c16bd6eff156c5e36c62969e68c06177a4518424dab1c7ed12e7f43" => :el_capitan
    sha256 "b1483446d24800cffa43ff8d3fa94d0c2ee906fefbc84cf84ea93d046e58b2f4" => :yosemite
    sha256 "52cfa0b813caee97ecbae5128f39329a0124ba60f3328c1db2bf296e839403ed" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    # parallel make does not work, fixed in next version (4.0.0)
    ENV.deparallelize
    # link with CoreFoundation, default in next version (4.0.0)
    ENV.append "LDFLAGS", "-framework CoreFoundation"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gig.h>
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << gig::libraryName() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgig", "-o", "test"
    assert_match "libgig", shell_output("./test")
  end
end

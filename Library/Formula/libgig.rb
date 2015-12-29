class Libgig < Formula
  desc "library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "http://download.linuxsampler.org/packages/libgig-3.3.0.tar.bz2"
  sha256 "d22a3c7ba13d920c1d4b6c218107ad105622ae9d1236ffbce007b98547774425"

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

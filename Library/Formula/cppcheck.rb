class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/1.72.tar.gz"
  sha256 "c718949e1ec22a8a0dca7e2953a55c502ef65e53ff9922fb91759388618faa7f"
  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha256 "95395daf0154293fba7b6254c278a128aad26fc3c9f0a73ac02200be7329eb60" => :el_capitan
    sha256 "ea7ca38db3bb2e08a9cffd9f003df61d865dad098a140dbec5d5458f085be9d5" => :yosemite
    sha256 "0e46747db20c2cb9fe2a505901db7f70be154a4326da528740e8cb1e3c1281a3" => :mavericks
  end

  option "without-rules", "Build without rules (no pcre dependency)"
  option "with-gui", "Build the cppcheck gui (requires Qt)"

  deprecated_option "no-rules" => "without-rules"

  depends_on "pcre" if build.with? "rules"
  depends_on "qt" if build.with? "gui"

  needs :cxx11

  def install
    ENV.cxx11

    # Man pages aren't installed as they require docbook schemas.

    # Pass to make variables.
    if build.with? "rules"
      system "make", "HAVE_RULES=yes", "CFGDIR=#{prefix}/cfg"
    else
      system "make", "HAVE_RULES=no", "CFGDIR=#{prefix}/cfg"
    end

    # CFGDIR is relative to the prefix for install, don't add #{prefix}.
    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "CFGDIR=/cfg", "install"

    if build.with? "gui"
      cd "gui" do
        if build.with? "rules"
          system "qmake", "HAVE_RULES=yes"
        else
          system "qmake", "HAVE_RULES=no"
        end

        system "make"
        prefix.install "cppcheck-gui.app"
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << "Hello World!" << endl;
        return 0;
      }
    EOS
    system "#{bin}/cppcheck", "test.cpp"
  end
end

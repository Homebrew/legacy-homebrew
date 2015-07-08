class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"

  stable do
    url "https://github.com/danmar/cppcheck/archive/1.69.tar.gz"
    sha256 "6e54f0dc97cbcc6c742cef4ceb1ade7f20f88af713a19c7613dba1d78eed6363"
  end

  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha256 "3f788dd4abcf544005030332c7c6228a27987699442548e007857ead6f13a5a7" => :yosemite
    sha256 "7716a9fa9ef5c47250552c9f67c6d024acdd90f42e0427848e24c8af4f8e770e" => :mavericks
    sha256 "8a81c8a4785239955506ef1f1bb37b0140eba63f20e0e8c2a9052a4afbd226f2" => :mountain_lion
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

    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "CFGDIR=#{prefix}/cfg", "install"

    # make sure cppcheck can find its configure directory, #26194
    prefix.install "cfg"

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

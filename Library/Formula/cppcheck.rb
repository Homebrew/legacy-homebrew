class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/1.71.tar.gz"
  sha256 "49f8d44516a1534eb01e3cc8300d60c3577c5e4339336defaf213d08ff914f1b"
  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha256 "57f0796aeae7641466857abb9f55786c62cd1970941756813f9559cf370a25e2" => :el_capitan
    sha256 "6f7e66fefcf465e8cf3171d9aa63584fe3eaaf9e7aa4c8c8e6b7f519bb7950cc" => :yosemite
    sha256 "ba9a7d4674ced19e545d25d973ea2127faa91a011940b925200f9cc177c34081" => :mavericks
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

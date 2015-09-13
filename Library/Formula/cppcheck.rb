class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/1.70.tar.gz"
  sha256 "4095de598b5cce9a06e90458a90f46e0307baeaab8a947dae73f287eda3c171f"
  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha256 "7755011515353f4b5c4a1c2ca4ab3722e4f9d3df7a0adbd4dfbc86797d1f1c9a" => :yosemite
    sha256 "f00b3dea581f6bb490e8977834471f927ad36174c151263f6f1fb4e1cbd56e93" => :mavericks
    sha256 "7e432d994967aed4e104661ef1dd5398cb4b264736b46d44d79a7f7177102c85" => :mountain_lion
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

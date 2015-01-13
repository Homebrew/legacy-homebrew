class Cppcheck < Formula
  homepage "http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page"
  url "https://github.com/danmar/cppcheck/archive/1.68.tar.gz"
  sha1 "f08ef07f750f92fafe4f960166072e9d1088d74e"

  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha1 "8191b30ed8620ed5de071bbe80053125f80438bc" => :yosemite
    sha1 "168ff653869991d73f5e49493bd690e17a56cee9" => :mavericks
    sha1 "d367cd0f3b392e5a93868179402c76e708b26b62" => :mountain_lion
  end

  option "without-rules", "Build without rules (no pcre dependency)"
  option "with-gui", "Build the cppcheck gui (requires Qt)"

  deprecated_option "no-rules" => "without-rules"

  depends_on "pcre" if build.with? "rules"
  depends_on "qt" if build.with? "gui"

  def install
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
        # fix make not finding cfg directory:
        # https://github.com/Homebrew/homebrew/issues/27756
        inreplace "gui.qrc", "../cfg/", "#{prefix}/cfg/"

        if build.with? "rules"
          system "qmake"
        else
          system "qmake", "HAVE_RULES=no"
        end

        system "make"
        bin.install "cppcheck-gui.app"
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

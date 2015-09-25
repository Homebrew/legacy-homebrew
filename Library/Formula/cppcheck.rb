class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/1.70.tar.gz"
  sha256 "4095de598b5cce9a06e90458a90f46e0307baeaab8a947dae73f287eda3c171f"
  head "https://github.com/danmar/cppcheck.git"

  bottle do
    revision 1
    sha256 "7fa6bf8c61c9ff88a5cdf259693287427aa0885a1f1e30ce5d85cf52eef6ec47" => :el_capitan
    sha256 "6c4b24741d60c941f2969afd39c1a5e1290263f7178ad78055a2dbbb307cb100" => :yosemite
    sha256 "460d77d134fb009c9ac20ab9ce521251fd57c80a1ca7b77b76cab06109b89dad" => :mavericks
    sha256 "595d3c1689fb381be84f16a41555eade205aee84e05e340ccfd18bcbc96cf4ef" => :mountain_lion
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

class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.6/swig-3.0.6.tar.gz"
  sha256 "c67f63ea11956106e4cda66416d5020330dc4ce2ee45057d39a9494ce33eca05"

  bottle do
    sha256 "fcf17b229413529bdc67ea25334fa79cada00af37297efdf44257bf0dcf52ab8" => :yosemite
    sha256 "d77b88f6dc08c87c5d1a49a0668fbe3545b3088eb6dad812ea216b817bc2a907" => :mavericks
    sha256 "4cbcda417d4429eb49fbf77e39c1d7898d39f1185c11c63b2b1ee5e2c8d5ddf6" => :mountain_lion
  end

  option :universal

  depends_on "pcre"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<-EOS.undent
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<-EOS.undent
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    system ENV.cc, "-c", "test.c"
    system ENV.cc, "-c", "test_wrap.c", "-I/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-flat_namespace", "-undefined", "suppress", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("ruby run.rb").strip
  end
end

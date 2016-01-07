class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz"
  sha256 "58a475dbbd4a4d7075e5fe86d4e54c9edde39847cdb96a3053d87cb64a23a453"

  bottle do
    sha256 "1290314a7e3c7447a17e16dcc7dbdbc2a090293b4b1c6170f2a4893ccf4fdb43" => :el_capitan
    sha256 "0dd343668d19966199600282904d3ba799234355f35e0bea56a5e2b278d1ab25" => :yosemite
    sha256 "c2b2635904546125d52fd7ab452fafb522567d12bd1c98f045d6499dabb8d38d" => :mavericks
    sha256 "4e4f96d939d6624dbe25902c139fbe29424f7e1a71d06a15f04fefd0a1348f9f" => :mountain_lion
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

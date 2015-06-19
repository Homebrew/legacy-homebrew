class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "http://xqilla.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.1.tar.gz"
  sha256 "5ba1c1060c7d7e1dae537d4e1388d23b278a2177c7652e33121d481907d25d68"

  bottle do
    cellar :any
    sha256 "f3f90fae2c2ca2b4dffb8d8261ee60c2d9c2efcf9c9dee534f252fafb647616b" => :yosemite
    sha256 "f9aaade5ef6770609d770579279c55ea5c02d0877a747d75e514b287161af100" => :mavericks
    sha256 "35b3e6c6d56af36f717f067a759daf2f9aaa135cd519245e925a83e480e1781a" => :mountain_lion
  end

  depends_on "xerces-c"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-xerces=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <xqilla/xqilla-simple.hpp>

      int main(int argc, char *argv[]) {
        XQilla xqilla;
        AutoDelete<XQQuery> query(xqilla.parse(X("1 to 100")));
        AutoDelete<DynamicContext> context(query->createDynamicContext());
        Result result = query->execute(context);
        Item::Ptr item;
        while(item == result->next(context)) {
          std::cout << UTF8(item->asString(context)) << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lxqilla",
           "-I#{Formula["xerces-c"].opt_include}",
           "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c",
           testpath/"test.cpp", "-o", testpath/"test"
    system testpath/"test"
  end
end

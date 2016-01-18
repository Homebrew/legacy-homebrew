class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "http://xqilla.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.2.tar.gz"
  sha256 "5ae0aed4091521d5c2f541093e02a81ebe55a9087ba735f80b110068584e217c"

  bottle do
    cellar :any
    sha256 "f5c1033698c6dfe371182dac4311b3ad2e1d8e1f5c23f0a6fd6f579e45f52ad4" => :el_capitan
    sha256 "c1ca983aa5ba4063e5fb540353852e75139af571dee32ae086fe593a781f8b53" => :yosemite
    sha256 "696b3fa43a0847c6614513d0e84c148dcb7d2ea352109153e7e21e735397ee08" => :mavericks
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

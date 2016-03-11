class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "http://xqilla.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.2.tar.gz"
  sha256 "5ae0aed4091521d5c2f541093e02a81ebe55a9087ba735f80b110068584e217c"

  bottle do
    cellar :any
    revision 1
    sha256 "467093e2e7aa5d27ef6fbb4b38b4272847b58f0034a274dee32a47d03269a4fc" => :el_capitan
    sha256 "25adad84e1e9c8aef23c2acde2a7848a1899d291628ffbe6c03c6296fbeb39f4" => :yosemite
    sha256 "29918d50fd8318817ddea7f7e99ee9f6e144c631fcbeaa19c5b0f478223b1d39" => :mavericks
  end

  depends_on "xerces-c"

  conflicts_with "zorba", :because => "Both supply xqc.h"

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

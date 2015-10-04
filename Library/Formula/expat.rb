class Expat < Formula
  desc "XML 1.0 parser"
  homepage "http://www.libexpat.org"
  url "https://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz"
  mirror "https://fossies.org/linux/www/expat-2.1.0.tar.gz"
  sha256 "823705472f816df21c8f6aa026dd162b280806838bb55b3432b0fb1fcca7eb86"
  revision 1

  head ":pserver:anonymous:@expat.cvs.sourceforge.net:/cvsroot/expat", :using => :cvs

  bottle do
    cellar :any
    revision 1
    sha256 "c866592f74d84d50d2465120deac0309ea2a192dbc647785553cce5d42c445e6" => :el_capitan
    sha256 "159b1125406c697ec737f7ba548c2f43cde630e6c78ad02cb3071786f8799d6b" => :yosemite
    sha256 "bfea179a87f894127f9a7454ef9bf31800b29f7579ec06cbed34aae02517f8f6" => :mavericks
    sha256 "760375f5814e2b1b3c1f2f2c8b31b0ed37fdc5022b4ca484dc6b8f106d14a72a" => :mountain_lion
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "expat.h"

      static void XMLCALL my_StartElementHandler(
        void *userdata,
        const XML_Char *name,
        const XML_Char **atts)
      {
        printf("tag:%s|", name);
      }

      static void XMLCALL my_CharacterDataHandler(
        void *userdata,
        const XML_Char *s,
        int len)
      {
        printf("data:%.*s|", len, s);
      }

      int main()
      {
        static const char str[] = "<str>Hello, world!</str>";
        int result;

        XML_Parser parser = XML_ParserCreate("utf-8");
        XML_SetElementHandler(parser, my_StartElementHandler, NULL);
        XML_SetCharacterDataHandler(parser, my_CharacterDataHandler);
        result = XML_Parse(parser, str, sizeof(str), 1);
        XML_ParserFree(parser);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end

require 'formula'

class HtmlXmlUtils < Formula
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.4.tar.gz'
  sha1 'ff0084b617a1f8bee9353158a2a7dbf80f086373'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Undefined symbols for architecture x86_64:
        "_min", referenced from:
            _write_index_item in hxindex.o
      EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make install"
  end
end

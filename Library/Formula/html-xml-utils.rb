require 'formula'

class HtmlXmlUtils < Formula
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-5.5.tar.gz'
  sha1 'ec1e6d52825a6aa9e9aff0a34679621de5e419ba'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Undefined symbols for architecture x86_64:
        "_min", referenced from:
            _write_index_item in hxindex.o
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make install"
  end
end

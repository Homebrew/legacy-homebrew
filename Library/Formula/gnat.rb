require 'formula'

class Gnat < Formula
  homepage 'http://libre.adacore.com'
  url 'http://mirrors.cdn.adacore.com/art/9efa7cdc57e9183edea6c3fbbceac6a89ffb3195'
  sha1 '7c649d721718647da9c37b3610934c3db576e795'

  keg_only "This binary package contains files that conflict with GCC/LLVM."
  def install
    system "make", "prefix=#{prefix}", "ins-all"
    # Remove redundant files.
    system "rm", "#{lib}/libgomp.spec", "#{lib}/libitm.spec", "#{lib}/libstdc++.a-gdb.py"
    # Remove symbolic links.
    system "rm", "#{lib}/libxmlada_dom.dylib.2013", "#{lib}/libxmlada_input_sources.dylib.2013", "#{lib}/libxmlada_sax.dylib.2013", "#{lib}/libxmlada_schema.dylib.2013", "#{lib}/libxmlada_unicode.dylib.2013"
  end
end

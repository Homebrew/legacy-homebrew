require 'formula'

class Freeling < Formula
  homepage 'http://nlp.lsi.upc.edu/freeling/'
  url 'http://devel.cpl.upc.edu/freeling/downloads/32'
  version '3.1'
  sha1 '42dbf7eec6e5c609e10ccc60768652f220d24771'

  depends_on 'icu4c'
  depends_on 'boost' => 'with-icu'
  depends_on 'libtool' => :build

  def install
    icu4c = Formula['icu4c']
    libtool = Formula['libtool']
    ENV.append 'LDFLAGS', "-L#{libtool.lib}"
    ENV.append 'LDFLAGS', "-L#{icu4c.lib}"
    ENV.append 'CPPFLAGS', "-I#{libtool.include}"
    ENV.append 'CPPFLAGS', "-I#{icu4c.include}"

    system "./configure", "--prefix=#{prefix}", "--enable-boost-locale"

    system "make install"
  end

  test do
    system "echo 'Hello world' | #{bin}/analyze -f #{share}/freeling/config/en.cfg | grep -c 'world world NN 1'"
  end
end

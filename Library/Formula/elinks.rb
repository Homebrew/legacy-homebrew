require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  sha1 'd13edc1477d0ab32cafe7d3c1f3a23ae1c0a5c54'
  revision 1

  bottle do
    sha1 "583e1341f43122ae82e2f1432c2a836d33450fc5" => :mavericks
    sha1 "326f4f9c079d42c11463b224d1a33e1b74705505" => :mountain_lion
    sha1 "069240528115caa0885c2ead5f83515dbab6a3f8" => :lion
  end

  devel do
    url 'http://elinks.cz/download/elinks-0.12pre6.tar.bz2'
    version '0.12pre6'
    sha1 '3517795e8a390cb36ca249a5be6514b9784520a5'
  end

  head do
    url 'http://elinks.cz/elinks.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey",
                          "--enable-256-colors"
    system "make install"
  end

  test do
    (testpath/"test.html").write <<-EOS.undent
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/, `elinks test.html`
  end
end

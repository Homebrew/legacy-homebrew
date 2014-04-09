require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  sha1 'd13edc1477d0ab32cafe7d3c1f3a23ae1c0a5c54'

  bottle do
    revision 1
    sha1 "a79d42beb1bb9f775d18a03dc625103a9b1bb857" => :mavericks
    sha1 "ae13670b20cd68276113c516ab11558a422e2718" => :mountain_lion
    sha1 "fdaa632b87faed30cbeb923d65d0e453b6601637" => :lion
  end

  devel do
    url 'http://elinks.cz/download/elinks-0.12pre6.tar.bz2'
    version '0.12pre6'
    sha1 '3517795e8a390cb36ca249a5be6514b9784520a5'
  end

  head do
    url 'http://elinks.cz/elinks.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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

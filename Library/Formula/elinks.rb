require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  sha1 'd13edc1477d0ab32cafe7d3c1f3a23ae1c0a5c54'

  head 'http://elinks.cz/elinks.git'

  devel do
    url 'http://elinks.cz/download/elinks-0.12pre6.tar.bz2'
    version '0.12pre6'
    sha1 '15fb38fa938a0eec9d5f22fdd538a6785e2854af'
  end

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey",
                          "--enable-256-colors"
    system "make install"
  end
end

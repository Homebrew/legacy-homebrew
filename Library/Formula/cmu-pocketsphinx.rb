require 'formula'

class CmuPocketsphinx < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz'
  sha1 'd9efdd0baddd2e47c2ba559caaca62ffa0c0eede'
  head "https://github.com/cmusphinx/pocketsphinx.git"

  depends_on 'pkg-config' => :build
  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end
  depends_on 'cmu-sphinxbase'

  def install
    system (if build.head? then "./autogen.sh" else "./configure" end),
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install"
  end
end

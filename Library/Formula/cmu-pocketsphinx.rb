require 'formula'

class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz'
  sha1 'd9efdd0baddd2e47c2ba559caaca62ffa0c0eede'

  head do
    url "https://github.com/cmusphinx/pocketsphinx.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'cmu-sphinxbase'

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

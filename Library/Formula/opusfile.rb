require 'formula'

class Opusfile < Formula
  homepage 'http://www.opus-codec.org/'
  url 'http://downloads.xiph.org/releases/opus/opusfile-0.6.tar.gz'
  sha1 '2422e3c7bf6105a832226850b19053ec5ac41293'

  head do
    url "https://git.xiph.org/opusfile.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'opus'
  depends_on 'libogg'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end

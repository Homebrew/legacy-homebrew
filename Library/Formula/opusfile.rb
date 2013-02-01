require 'formula'

class Opusfile < Formula
  homepage 'http://www.opus-codec.org/'
  url 'http://downloads.xiph.org/releases/opus/opusfile-0.2.tar.gz'
  sha1 'db020e25178b501929a11b0e0f469890f4f4e6fa'

  head 'https://git.xiph.org/opusfile.git'

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

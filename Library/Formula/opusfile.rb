require 'formula'

class Opusfile < Formula
  homepage 'http://www.opus-codec.org/'
  url 'http://downloads.xiph.org/releases/opus/opusfile-0.4.tar.gz'
  sha1 'd514e57ffc051e4359b9bc13d6fc8805a26cdd3b'

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

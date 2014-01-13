require 'formula'

class Opusfile < Formula
  homepage 'http://www.opus-codec.org/'
  url 'http://downloads.xiph.org/releases/opus/opusfile-0.5.tar.gz'
  sha1 '1ba9dabbbaa35034af8167661a918df6c003317e'

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

require 'formula'

class Opusfile < Formula
  homepage 'http://www.opus-codec.org/'
  head 'https://git.xiph.org/opusfile.git'

  url 'http://downloads.xiph.org/releases/opus/opusfile-0.1.tar.gz'
  sha1 '5e84cd600fa9da1ec08588644436a29cf5e9de67'

  depends_on 'pkg-config' => :build
  depends_on 'opus'
  depends_on 'libogg'

  # A naive build works against Apple openssl, but brew gets
  # unresolved symbol warnings. I couldn't figure out why.
  depends_on 'openssl'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end

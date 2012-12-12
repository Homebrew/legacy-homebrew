require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.0.1.tar.gz'
  sha1 '4d6358232606fbce80d9e63ed0d9b3b49fafb711'

  head 'https://git.xiph.org/opus.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--disable-doc",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

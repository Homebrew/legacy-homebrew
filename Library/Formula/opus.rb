require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.0.3.tar.gz'
  sha1 '5781bdd009943deb55a742ac99db20a0d4e89c1e'

  head do
    url 'https://git.xiph.org/opus.git'

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

require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-0.9.14.tar.gz'
  sha1 '5a70dce8523b7be2e3d39e3d0f97fd3123a4c331'

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

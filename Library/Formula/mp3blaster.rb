require 'formula'

class Mp3blaster < Formula
  homepage 'http://mp3blaster.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.5/mp3blaster-3.2.5.tar.gz'
  sha1 '6a0fc892e0739a409735e85b18089c0e25fcc577'

  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end

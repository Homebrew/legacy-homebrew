require 'formula'

class Setweblocthumb < Formula
  homepage 'http://hasseg.org/setWeblocThumb'
  url 'https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz'
  sha1 '60fb2858e6f45216166f31e951432805d7f9dcc0'

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    system "#{bin}/setWeblocThumb"
  end
end

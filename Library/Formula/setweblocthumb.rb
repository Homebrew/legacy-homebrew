require 'formula'

class Setweblocthumb < Formula
  homepage 'http://hasseg.org/setWeblocThumb'
  url 'https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz'
  sha1 '2837bc2a4a8c1011c95c05ee45d6232c84552eca'

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    system "#{bin}/setWeblocThumb"
  end
end

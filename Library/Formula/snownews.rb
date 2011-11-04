require 'formula'

class Snownews < Formula
  url 'https://kiza.kcore.de/media/software/snownews/snownews-1.5.12.tar.gz'
  homepage 'https://kiza.kcore.de/media/software/snownews'
  md5 '80da8943fc5aa96571924aec0087d4c0'

  def install
    system "./configure", "--disable-nls", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "snownews"
  end
end

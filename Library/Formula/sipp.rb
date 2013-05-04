require 'formula'

class Sipp < Formula
  homepage 'http://sipp.sourceforge.net/'
  url 'http://sourceforge.net/projects/sipp/files/sipp/3.3/sipp-3.3.tar.gz'
  sha1 'a8e088b7e1e3673eddfbe2fd4e1486dd87919520'

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end

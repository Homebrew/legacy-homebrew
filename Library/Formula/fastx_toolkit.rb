require 'formula'

class FastxToolkit < Formula
  url 'http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.tar.bz2'
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  md5 '6d233ff4ae3d52c457d447179f073a56'

  depends_on 'libgtextutils'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "fastx_uncollapser -h; [ $? == 1 ]"
  end
end

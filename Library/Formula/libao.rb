require 'formula'

class Libao < Formula
  homepage 'http://www.xiph.org/ao/'
  url 'http://downloads.xiph.org/releases/ao/libao-1.1.0.tar.gz'
  sha1 '9301bc4886f170c7122ab62677fb71cf001c04fd'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make install"
  end
end

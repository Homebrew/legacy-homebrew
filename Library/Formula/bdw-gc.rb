require 'formula'

class BdwGc < Formula
  homepage 'http://www.hboehm.info/gc/'
  url 'http://www.hboehm.info/gc/gc_source/gc-7.4.0.tar.gz'
  sha1 '82f031a5a6db004df3cf8f1b1e72dd6b313ab032'

  depends_on "libatomic_ops"
  depends_on 'pkg-config' => :build

  bottle do
    cellar :any
    sha1 "267d3e346e5d8a9fff781ee58a7aa3b33e31b3db" => :mavericks
    sha1 "a92904c2e10891252bb212eb4a438094a36de8c8" => :mountain_lion
    sha1 "ecc4b3bded24d5a48255c4c4d5295680d5befcf2" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end

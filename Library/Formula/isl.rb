require 'formula'

class Isl < Formula
  homepage 'http://freecode.com/projects/isl'
  url 'http://repo.or.cz/r/isl.git', :tag => 'isl-0.12.1'

  head 'http://repo.or.cz/r/isl.git'

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool => :build
  depends_on 'gmp'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end
end

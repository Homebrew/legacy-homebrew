require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.8/downloads/hwloc-1.8.tar.gz'
  sha1 '6c92ad6fc795ef380637b38835f20a01192d6ad5'

  depends_on 'pkg-config' => :build
  depends_on 'cairo' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

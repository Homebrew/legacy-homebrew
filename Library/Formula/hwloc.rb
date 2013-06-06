require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.6/downloads/hwloc-1.6.2.tar.gz'
  sha1 'aa9d9ca75c7d7164f6bf3a52ecd77340eec02c18'

  depends_on 'pkg-config' => :build
  # Uses Cairo, tested against Snow Leopard version

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

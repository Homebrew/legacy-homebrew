require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.4/downloads/hwloc-1.4.2.tar.gz'
  sha1 'b33421432071d1de638b16e06ad7eb5b8922a32c'

  depends_on 'pkg-config' => :build
  # Uses Cairo, tested against Snow Leopard version

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

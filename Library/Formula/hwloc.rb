require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.5/downloads/hwloc-1.5.tar.gz'
  sha1 '0ff8c81481987627dc21b3ed826caaefc94d4d0f'

  depends_on 'pkg-config' => :build
  # Uses Cairo, tested against Snow Leopard version

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

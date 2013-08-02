require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.7/downloads/hwloc-1.7.1.tar.gz'
  sha1 'b975dd60b72859deafb6b7cfa184595614bb4683'

  depends_on 'pkg-config' => :build
  # Uses Cairo, tested against Snow Leopard version

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

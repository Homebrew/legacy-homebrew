require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.6/downloads/hwloc-1.6.tar.gz'
  sha1 'cdf855648c02b24ed3f70df6423470830a4cf911'

  depends_on 'pkg-config' => :build
  # Uses Cairo, tested against Snow Leopard version

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

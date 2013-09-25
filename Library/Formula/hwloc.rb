require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.7/downloads/hwloc-1.7.2.tar.gz'
  sha1 '687555653fd3529ae2045e77072ee2a641416fda'

  depends_on 'pkg-config' => :build
  depends_on 'cairo' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

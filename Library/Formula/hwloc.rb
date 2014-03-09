require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url 'http://www.open-mpi.org/software/hwloc/v1.8/downloads/hwloc-1.8.1.tar.gz'
  sha1 '4ed7c5d873fd16974b756efa5727c5b2caaa0118'

  depends_on 'pkg-config' => :build
  depends_on 'cairo' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

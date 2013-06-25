require 'formula'

# Documentation: http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/About 

class Libiodbc < Formula
  homepage ''
  url 'http://sourceforge.net/projects/iodbc/files/iodbc/3.52.8/libiodbc-3.52.8.tar.gz/download'
  sha1 '93a3f061afff3152c5fcee1e5af8b802760a7e74'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build

  def install
    # run bootstrap.sh
    system "sh",  "./bootstrap.sh"
    # ENV.j1  # if your formula's build system can't parallelize
    
    system "./configure", "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "make", "check"
  end
end

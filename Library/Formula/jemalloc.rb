require 'formula'

class Jemalloc < Formula
  homepage 'http://www.canonware.com/jemalloc/download.html'
  url 'http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2'
  sha1 '40c0892b172e5dc14a6cea6fe4edda7dea4f3a68'
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha1 "80636f2554f09d03acfff3669c5bb40efaa8b55a" => :mavericks
    sha1 "70e3f2ed51b17eb561965465a677e7babf2e8ab4" => :mountain_lion
    sha1 "42ae67660585875628fec3fb12b4b391c8f40b22" => :lion
  end

  def install
    system './configure', '--disable-debug', "--prefix=#{prefix}"
    system 'make install'

    # This otherwise conflicts with google-perftools
    mv "#{bin}/pprof", "#{bin}/jemalloc-pprof"
  end
end

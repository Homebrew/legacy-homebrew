require 'formula'

class Alpinocorpus < Formula
  homepage 'http://github.com/rug-compling/alpinocorpus'
  head 'https://github.com/rug-compling/alpinocorpus.git', :branch => 'master'

  depends_on 'cmake'
  depends_on 'boost'
  depends_on 'xerces-c'
  depends_on 'xqilla'
  depends_on 'dbxml'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

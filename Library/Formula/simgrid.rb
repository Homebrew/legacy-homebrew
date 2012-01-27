require 'formula'

class Simgrid < Formula
  url 'https://gforge.inria.fr/frs/download.php/29207/simgrid-3.6.2.tar.gz'
  homepage 'http://simgrid.gforge.inria.fr'
  md5 '35b10c0fb6d47bdbbf19417ab0ab2e6c'

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'graphviz'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # In the 3.6.2 following tests seems to be failing on OSX Lion
    # 105 - msg-chord-raw-parallel (Failed)
    # 124 - gras-pmm-sg-64-raw (Failed)
    # 139 - tracing-ms (Failed)
    # 156 - testall (OTHER_FAULT)
    #system "make check"
    #system "ctest"
    system "false"
  end
end

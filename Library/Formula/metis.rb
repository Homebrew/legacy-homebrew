require 'formula'

class Metis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  md5 'd3848b454532ef18dc83e4fb160d1e10'

  def install
    system "make"
    bin.install %w(pmetis kmetis oemetis onmetis partnmesh partdmesh mesh2nodal mesh2dual graphchk Graphs/mtest)
    lib.install 'libmetis.a'
    include.install Dir['Lib/*.h']
  end
end

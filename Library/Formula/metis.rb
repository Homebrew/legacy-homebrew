require 'formula'

class Metis <Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-4.0.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  md5 '0aa546419ff7ef50bd86ce1ec7f727c7'

  def install
    system "make"
    bin.install ['pmetis', 'kmetis', 'oemetis', 'onmetis', 'partnmesh', 
      'partdmesh', 'mesh2nodal', 'mesh2dual', 'graphchk', 'Graphs/mtest']
    lib.install 'libmetis.a'
    include.install ['Lib/metis.h', 'Lib/defs.h', 'Lib/macros.h', 'Lib/rename.h',
      'Lib/proto.h', 'Lib/struct.h']
  end
end

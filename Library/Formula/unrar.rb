require 'brewkit'

ALL_CPP=<<-EOS
#include "errhnd.cpp"
ErrorHandler ErrHandler;
#include "rar.cpp"
#include "strlist.cpp"
#include "strfn.cpp"
#include "pathfn.cpp"
#include "savepos.cpp"
#include "smallfn.cpp"
#include "global.cpp"
#include "file.cpp"
#include "filefn.cpp"
#include "filcreat.cpp"
#include "archive.cpp"
#include "arcread.cpp"
#include "unicode.cpp"
#include "system.cpp"
#include "isnt.cpp"
#include "crypt.cpp"
#include "crc.cpp"
#include "rawread.cpp"
#include "encname.cpp"
#include "resource.cpp"
#include "match.cpp"
#include "timefn.cpp"
#include "rdwrfn.cpp"
#include "consio.cpp"
#include "options.cpp"
#include "ulinks.cpp"
#include "rarvm.cpp"
#include "rijndael.cpp"
#include "getbits.cpp"
#undef rol
#include "sha1.cpp"
#include "extinfo.cpp"
#include "extract.cpp"
#include "volume.cpp"
#include "list.cpp"
#include "find.cpp"
#include "unpack.cpp"
#include "cmddata.cpp"
#include "filestr.cpp"
#include "recvol.cpp"
#include "rs.cpp"
#include "scantree.cpp"
EOS

class Unrar <Formula
  @url='http://www.rarlab.com/rar/unrarsrc-3.9.4.tar.gz'
  @md5='1800a2242911fc118f6a2b084d0c22c1'
  @homepage='http://www.rarlab.com'

  def install
    # by compiling all in one unit, g++ optimises slightly better
    # be warned: this trick doesn't work very often! And I'd only do it for
    # very stable source trees as if they change stuff it sucks for you.
    File.open('all.cpp', 'w') {|f| f.write ALL_CPP}
    system "g++ #{ENV['CXXFLAGS']} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE all.cpp -o unrar"
    bin.install 'unrar'
    
    FileUtils.mv 'license.txt', 'COPYING'
    FileUtils.mv 'readme.txt', 'README'
  end
end
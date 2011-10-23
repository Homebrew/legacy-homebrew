require 'formula'

class Libid3tag < Formula
  url 'http://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz'
  md5 'e5808ad997ba32c498803822078748c3'

  def id3tag_pc
    return <<-EOS
prefix=#{HOMEBREW_PREFIX}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: id3tag
Description: ID3 tag reading library
Version: #{@version}
Requires:
Conflicts:
Libs: -L${libdir} -lid3tag -lz
Cflags: -I${includedir}
    EOS
  end


  def homepage
    Formula.factory('mad').homepage
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    (lib+'pkgconfig/id3tag.pc').write id3tag_pc
  end
end

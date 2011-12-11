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
  
  def patches
    base = "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/"
    { :p1 => ["libid3tag-0.15.1b-utf16.patchlibid3tag-0.15.1b-utf16.patch", # patch for utf16 (memoroy leaks)  
              "libid3tag-0.15.1b-unknown-encoding.patch", # encoding patch
              "libid3tag-0.15.1b-compat.patch",
              "libid3tag-0.15.1b-file-write.patch",
              ].map { |file_name| "#{base}/#{file_name}" },
              
      :p0 => ["libid3tag-0.15.1b-64bit-long.patch", # typedef for 64 bits long
              "libid3tag-0.15.1b-fix_overflow.patch", # overflow protection
              "libid3tag-0.15.1b-tag.patch", # tag
             ].map { |file_name| "#{base}/#{file_name}" },
              
      :p2 => ["libid3tag-0.15.1b-a_capella.patch", # A Capella type
             ].map { |file_name| "#{base}/#{file_name}" }
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    (lib+'pkgconfig/id3tag.pc').write id3tag_pc
  end
end

require 'formula'

class Libid3tag < Formula
  url 'http://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz'
  sha1 '4d867e8a8436e73cd7762fe0e85958e35f1e4306'

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

  # Fixes serious memory leaks; see https://bugs.launchpad.net/mixxx/+bug/403586
  def patches
    base = "http://mirror.ovh.net/gentoo-portage/media-libs/libid3tag/files/0.15.1b/"
    # patch for utf-16 (memory leaks)
    { :p1 => ["libid3tag-0.15.1b-utf16.patchlibid3tag-0.15.1b-utf16.patch",
              "libid3tag-0.15.1b-unknown-encoding.patch",
              "libid3tag-0.15.1b-compat.patch",
              "libid3tag-0.15.1b-file-write.patch",
              ].map { |file_name| "#{base}/#{file_name}" },

      # typedef for 64-bit long + buffer overflow
      :p0 => ["libid3tag-0.15.1b-64bit-long.patch",
              "libid3tag-0.15.1b-fix_overflow.patch",
              "libid3tag-0.15.1b-tag.patch",
             ].map { |file_name| "#{base}/#{file_name}" },

      # corrects "a cappella" typo
      :p2 => ["libid3tag-0.15.1b-a_capella.patch",
             ].map { |file_name| "#{base}/#{file_name}" }
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    (lib+'pkgconfig/id3tag.pc').write id3tag_pc
  end
end

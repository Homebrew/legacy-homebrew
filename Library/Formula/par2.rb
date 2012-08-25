require 'formula'

class Par2 < Formula
  homepage 'http://parchive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/parchive/par2cmdline/0.4/par2cmdline-0.4.tar.gz'
  sha1 '2fcdc932b5d7b4b1c68c4a4ca855ca913d464d2f'

  conflicts_with "par2tbb",
    :because => "par2 and par2tbb install the same binaries."

  def patches
    [
      "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/par2cmdline/files/par2cmdline-0.4-gcc4.patch?revision=1.1",
      # Clang doesn't like variable length arrays of non-POD types.
      DATA
    ]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/par2fileformat.h b/par2fileformat.h
index 9920b24..248cfaf 100644
--- a/par2fileformat.h
+++ b/par2fileformat.h
@@ -84,7 +84,7 @@ struct FILEVERIFICATIONPACKET
   PACKET_HEADER         header;
   // Body
   MD5Hash               fileid;     // MD5hash of file_hash_16k, file_length, file_name
-  FILEVERIFICATIONENTRY entries[];
+  FILEVERIFICATIONENTRY entries[0];
 } PACKED;
 
 // The file description packet is used to record the name of the file,

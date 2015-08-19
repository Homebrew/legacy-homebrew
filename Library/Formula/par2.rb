class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "http://parchive.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/parchive/par2cmdline/0.4/par2cmdline-0.4.tar.gz"
  sha256 "9e32b7dbcf7bca8249f98824757d4868714156fe2276516504cd26f736e9f677"

  conflicts_with "par2tbb",
    :because => "par2 and par2tbb install the same binaries."

  # Clang doesn't like variable length arrays of non-POD types.
  patch :DATA

  # Fixes compilation with GCC 4 and still required for clang
  patch do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/par2cmdline/files/par2cmdline-0.4-gcc4.patch?revision=1.1"
    sha256 "eda0a381f944b1bc9d3d78bf4526f77620bcb01de48abcb08878178e47c833f7"
  end

  # http://parchive.cvs.sourceforge.net/viewvc/parchive/par2-cmdline/par2creatorsourcefile.cpp?r1=1.4&r2=1.5
  patch :p0 do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/par2cmdline/files/par2cmdline-0.4-offset.patch?revision=1.2"
    sha256 "c4820b11376c9932ece944752ddd388fb50fcbcd47aaadda073997142952d969"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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

class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/107/libssh-0.6.4.tar.gz"
  sha1 "073bf53d9e02f7cfbcc5d8738ca1c9ffb2edd247"

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    sha1 "de5ef207ed3ae4d79f180a5835fe491409a0804d" => :yosemite
    sha1 "3de5d0a02be7bda59dabe91cd7db4ece978d25bb" => :mavericks
    sha1 "983355b795316434c54dd61e85495a808a147845" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  # Fix compilation on 10.10
  # https://red.libssh.org/issues/164
  # https://red.libssh.org/issues/174
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end

__END__
diff --git a/ConfigureChecks.cmake b/ConfigureChecks.cmake
index 8f76af8..0ce7a31 100644
--- a/ConfigureChecks.cmake
+++ b/ConfigureChecks.cmake
@@ -101,8 +101,8 @@ check_function_exists(snprintf HAVE_SNPRINTF)
 check_function_exists(poll HAVE_POLL)
 check_function_exists(select HAVE_SELECT)
 check_function_exists(getaddrinfo HAVE_GETADDRINFO)
-check_function_exists(ntohll HAVE_NTOHLL)
-check_function_exists(htonll HAVE_HTONLL)
+check_symbol_exists(ntohll arpa/inet.h HAVE_NTOHLL)
+check_symbol_exists(htonll arpa/inet.h HAVE_HTONLL)
 
 if (WIN32)
     check_function_exists(_strtoui64 HAVE__STRTOUI64)

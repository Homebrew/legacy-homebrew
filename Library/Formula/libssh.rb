require "formula"

class Libssh < Formula
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz"
  sha1 "8189255e0f684d36b7ca62739fa0cd5f1030a467"
  revision 2

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    revision 1
    sha1 "199ee5e4c60ccac22f38567d903cf34607b59474" => :yosemite
    sha1 "7a819a38b87d47a63b184faa6cd1db57106db1a2" => :mavericks
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

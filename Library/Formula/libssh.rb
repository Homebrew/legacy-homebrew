require "formula"

class Libssh < Formula
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz"
  sha1 "8189255e0f684d36b7ca62739fa0cd5f1030a467"
  revision 2

  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    sha1 "84717d23f7d4e59d847bbc2b3b91a2edb9e05709" => :mavericks
    sha1 "92158c3da484ae5073004c9e471bb458c61e08e3" => :mountain_lion
    sha1 "bd75561291499decf22001b0ba09ae41a3089dbb" => :lion
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

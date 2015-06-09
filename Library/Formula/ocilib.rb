class OracleHomeVar < Requirement
  fatal true
  satisfy ENV["ORACLE_HOME"]

  def message; <<-EOS.undent
      To use this formula you have to set the ORACLE_HOME environment variable.
      You might need to create a symbolic link without version number
      for the libclntsh library.
      Check Oracle Instant Client documentation for more information.
    EOS
  end
end

class Ocilib < Formula
  desc "Open source C and C++ library for accessing Oracle Databases"
  homepage "http://www.ocilib.net/"
  url "https://github.com/vrogier/ocilib/releases/download/v4.1.0/ocilib-4.1.0-gnu.tar.gz"
  sha256 "d86c1e6d5ef33541299996b76497a1271498cdcf5720ee0f1248a0b78dfb3a0c"

  head "https://github.com/vrogier/ocilib.git"

  option "with-charset-wide", "Use wide charset with Oracle OCI libraries"

  depends_on OracleHomeVar

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-oracle-headers-path=#{ENV["ORACLE_HOME"]}/sdk/include",
                          "--with-oracle-lib-path=#{ENV["ORACLE_HOME"]}",
                          "--with-oracle-charset=#{build.with?("charset-wide") ? "wide" : "ansi"}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "ocilib.h"

      int main(void)
      {
        return OCI_Initialize(NULL, NULL, OCI_ENV_DEFAULT | OCI_ENV_CONTEXT) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-locilib", "-o", "test"
    system "./test"
  end
end

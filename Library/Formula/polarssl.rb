class Polarssl < Formula
  homepage "https://polarssl.org/"
  # 1.4.0 will need dependents recompiled due to breaking binary compat.
  url "https://polarssl.org/download/polarssl-1.3.9-gpl.tgz"
  sha256 "d3605afc28ed4b7d1d9e3142d72e42855e4a23c07c951bbb0299556b02d36755"
  revision 1

  head "https://github.com/polarssl/polarssl.git"

  bottle do
    cellar :any
    sha1 "3664577b6d23bdbdb3e5d839431ecf0a8cbd96d4" => :yosemite
    sha1 "14f4185da9855d6c3501bb1e3efd85939eb58cf1" => :mavericks
    sha1 "c7e5981004ee144e00d17a2e28ff43a35f1eaeed" => :mountain_lion
  end

  depends_on "cmake" => :build

  conflicts_with "md5sha1sum", :because => "both install conflicting binaries"

  # Upstream patch for CVE-2015-1182. Remove with next release.
  # https://polarssl.org/tech-updates/security-advisories/polarssl-security-advisory-2014-04
  patch :DATA

  def install
    # Kills SSL2 Handshake & SSLv3 using upstream's recommended method.
    # Upstream, can you make this less hacky please?
    inreplace "include/polarssl/config.h" do |s|
      s.gsub! "#define POLARSSL_SSL_SRV_SUPPORT_SSLV2_CLIENT_HELLO", "//#define POLARSSL_SSL_SRV_SUPPORT_SSLV2_CLIENT_HELLO"
      s.gsub! "#define POLARSSL_SSL_PROTO_SSL3", "//#define POLARSSL_SSL_PROTO_SSL3"
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    # Why does PolarSSL ship with GNU's Hello included? Let's remove that.
    rm "#{bin}/hello"
    # Remove the pointless example application that hooks into system OpenSSL
    rm "#{bin}/o_p_test"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/sha1sum testfile.txt").strip
  end
end

__END__

diff --git a/library/asn1parse.c b/library/asn1parse.c
index a3a2b56..e2117bf 100644
--- a/library/asn1parse.c
+++ b/library/asn1parse.c
@@ -278,6 +278,8 @@ int asn1_get_sequence_of( unsigned char **p,
             if( cur->next == NULL )
                 return( POLARSSL_ERR_ASN1_MALLOC_FAILED );

+            memset( cur->next, 0, sizeof( asn1_sequence ) );
+
             cur = cur->next;
         }
     }

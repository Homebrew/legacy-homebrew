class Polarssl < Formula
  homepage "https://polarssl.org/"
  # 1.4.0 will need dependents recompiled due to breaking binary compat.
  url "https://polarssl.org/download/mbedtls-1.3.10-gpl.tgz"
  sha256 "746fd88e0c6623691fc56c4eed52e40a57b2da0ac80f6dd8995094aa6adb407e"

  head "https://github.com/polarssl/polarssl.git"

  bottle do
    cellar :any
    sha1 "8e96e686ff88e87ce6dac505e11a421f29dae80e" => :yosemite
    sha1 "cad7f83713440bedb0bd8ccce39380366c54dac7" => :mavericks
    sha1 "ec6014a8618ae437adc15b1bc0b7475cf6ce1593" => :mountain_lion
  end

  depends_on "cmake" => :build

  conflicts_with "md5sha1sum", :because => "both install conflicting binaries"

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
    rm_f "#{bin}/hello"
    # Remove the pointless example application that hooks into system OpenSSL
    rm_f "#{bin}/o_p_test"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/sha1sum testfile.txt").strip
  end
end

require "formula"

class OsspUuid < Formula
  homepage "http://www.ossp.org/pkg/lib/uuid/"
  url "http://ftp.de.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz"
  sha1 "3e22126f0842073f4ea6a50b1f59dcb9d094719f"
  revision 1

  bottle do
  end

  option :universal
  option "32-bit"

  def install
    if build.universal?
      ENV.universal_binary
    elsif build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{include}/ossp",
                          "--without-perl",
                          "--without-php",
                          "--without-pgsql"
    system "make"
    system "make install"
  end
end

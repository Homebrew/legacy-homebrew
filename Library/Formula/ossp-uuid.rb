class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "http://www.ossp.org/pkg/lib/uuid/"
  url "http://ftp.de.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  revision 1

  bottle do
    cellar :any
    sha256 "dc07aeeed6eba7f525745aebad48ea8fe9d2bd7d38b6ec61110783b670a2fd3c" => :el_capitan
    sha256 "91c89715dcd8021801b453d99321a150cc814526ff86d9c71bd9166b884b515c" => :yosemite
    sha256 "d42862adc71d3bdc481c7a4b49029aa44080be9d44b9b0700142dcb6ba182a55" => :mavericks
    sha256 "37097a2a7341c05126e60fa9b1a32a21bb3791d770852503168ba633282071b0" => :mountain_lion
    sha256 "d9ee9e1b764a9863834f6a8c2010038521f83a97b06ca3bb4d1c80ff9d1eae66" => :lion
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
    system "make", "install"
  end
end

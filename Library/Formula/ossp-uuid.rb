class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "http://www.ossp.org/pkg/lib/uuid/"
  url "http://ftp.de.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  revision 1

  bottle do
    cellar :any
    sha1 "bc8c6f93dd36442dfc24199062a73d1b4c47701f" => :yosemite
    sha1 "93c3c44dc456e49bed9cb8b3672144fc348298dc" => :mavericks
    sha1 "8a922934644663915eedc97f1a7da83725c646d2" => :mountain_lion
    sha1 "3fbf704b60a660becfba68753285ec70ee47cdeb" => :lion
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

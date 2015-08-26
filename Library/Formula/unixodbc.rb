class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.2.tar.gz"
  mirror "ftp://mirror.ovh.net/gentoo-distfiles/distfiles/unixODBC-2.3.2.tar.gz"
  sha256 "9c3459742f25df5aa3c10a61429bde51a6d4f11552c03095f1d33d7eb02b5c9a"
  revision 1

  bottle do
    revision 1
    sha1 "03dd766eb34bf59cc26c6ae55ca906f95b9e0c17" => :yosemite
    sha1 "29acdaea17aea46d72b8cfe061c84d3d58e3d594" => :mavericks
    sha1 "e9efe13f0a2eb4f162422dc3465411ab35b85aef" => :mountain_lion
  end

  option :universal

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  keg_only "Shadows system iODBC header files" if MacOS.version < :mavericks

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make", "install"
  end
end

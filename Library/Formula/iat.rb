class Iat < Formula
  desc "Converts many CD-ROM image formats to ISO9660"
  homepage "https://sourceforge.net/projects/iat.berlios/"
  url "https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2"
  sha256 "fb72c42f4be18107ec1bff8448bd6fac2a3926a574d4950a4d5120f0012d62ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "baadc7c40697b28b46c7541d617f65ee318b78efbdc4156c6527490616fd2dee" => :el_capitan
    sha256 "db517ebd84afdeabaf2e130faccb88f33f359d13eab3bfbb5e19013051ca7827" => :yosemite
    sha256 "31eb7a245b5ee29b983017b572bb6895abda8f32101b402889a96b0f316abe45" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system "make", "install"
  end
end

class Mkcue < Formula
  homepage "https://packages.debian.org/source/stable/mkcue"
  url "http://ftp.de.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"

  bottle do
    cellar :any
    sha256 "7bf9c893b89fa7bed8017a4f72fd8077222d97d9b140b26689070bac4afa0028" => :yosemite
    sha256 "84a62e48215ee6e658c50376623385329455ba0c0f164fedc5ec4f6c13d84874" => :mavericks
    sha256 "ed58ca425f237296f11dcd0c5c6248ae939cc02c0126ee1588d61d08effb822e" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test"
  end
end

class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://sourceforge.net/projects/sipsak.berlios/"
  url "https://downloads.sourceforge.net/project/sipsak.berlios/sipsak-0.9.6-1.tar.gz"
  version "0.9.6"
  sha256 "5064c56d482a080b6a4aea71821b78c21b59d44f6d1aa14c27429441917911a9"

  bottle do
    cellar :any
    sha256 "873d8cd50cce684ad55abbdf834157b4464c70877de9d1c37ad3c4ec9aaf6e10" => :yosemite
    sha256 "d70729739fcfe770fdfa997dc33cd04370a6cd2f6916e63adfed60473c4bfc55" => :mavericks
    sha256 "09d0961004d525dfc5f81bfe111884b401a09993fd83ff2f426016feb99607d4" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end

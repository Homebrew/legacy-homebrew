class Libidn2 < Formula
  desc "Internationalized domain name library conforming to IDNA2008 standards"
  homepage "https://www.gnu.org/software/libidn/"
  url "http://alpha.gnu.org/gnu/libidn/libidn2-0.10.tar.gz"
  sha256 "3d301890bdbb137424f5ea495f82730a4b85b6a2549e47de3a34afebeac3e0e3"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn2", "räksmörgås.se", "blåbærgrød.no"
  end
end

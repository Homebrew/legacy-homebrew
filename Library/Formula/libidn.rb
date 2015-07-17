class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.31.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.31.tar.gz"
  sha256 "afdf2fce91faea483ce24e26b5e3a9235e332029c9265d07214fd1cfaa08df08"

  bottle do
    cellar :any
    sha256 "d2aac625b2b178072eabb234dd624306bacbc6127ac7c515e9405b1cd9da388a" => :yosemite
    sha256 "712502e2028144e983f01a80f8fa293e8dc6ef421d6459181770bdb365717ac3" => :mavericks
    sha256 "0e231bfa4cbd4fcd8d5e047b33a1e0f6a8e320c50a7719adc1812b32d8bdf7db" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn", "räksmörgås.se", "blåbærgrød.no"
  end
end

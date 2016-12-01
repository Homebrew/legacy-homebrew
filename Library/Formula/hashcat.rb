class Hashcat < Formula
  desc "Advanced CPU-based password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  head "https://github.com/hashcat/hashcat.git"

  stable do
    url "https://codeload.github.com/hashcat/hashcat/tar.gz/2.00"
    sha256 "6325e6d75a4df3485adec00f74e5887326809c15ed31bfe74a12b62943245444"

    # not needed after https://github.com/hashcat/hashcat/pull/50
    fails_with :clang do
      cause <<-EOS.undent
        This formula does not compile with clang, use GCC or --HEAD
      EOS
    end
  end

  depends_on "lzip"
  depends_on "gmp"

  def install
    # this flag disappeared on modern GCCs (was used only for apple-gcc42)
    # not needed after https://github.com/hashcat/hashcat/pull/50
    inreplace "src/Makefile", "-fnested-functions", "" if stable?

    system "make", "osx", "CC_OSX64=cc", "LIBGMP_OSX64=#{Formula["gmp"].prefix}"

    bin.install "hashcat-cli64.app" => "hashcat"
  end

  test do
    system "#{bin}/hashcat", "--version"
  end
end

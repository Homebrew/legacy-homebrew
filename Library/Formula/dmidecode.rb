class Dmidecode < Formula
  desc "Dmidecode reports information about your system's hardware."
  homepage "https://github.com/cavaliercoder/dmidecode-osx"
  url "https://github.com/cavaliercoder/dmidecode-osx/archive/dmidecode-osx-3-0.tar.gz"
  version "3.0"
  sha256 "676eb69956b836759f2477dc5b71645bf88ec323512edc144d042ee7d1d78bb8"

  def install
    system "make", "dmidecode"
    bin.install "dmidecode"
    man8.install "man/dmidecode.8"
  end

  test do
    system "#{bin}/dmidecode"
  end
end

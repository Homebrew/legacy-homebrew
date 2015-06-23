class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7038.tar.gz"
  sha256 "00becccef59a628134a4099522c549e8aec60662e5558daa7999ad8a33ad339c"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "-V"
  end
end

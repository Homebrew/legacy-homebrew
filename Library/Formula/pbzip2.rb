class Pbzip2 < Formula
  homepage "http://compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.12/+download/pbzip2-1.1.12.tar.gz"
  sha256 "573bb358a5a7d3bf5f42f881af324cedf960c786e8d66dd03d448ddd8a0166ee"

  fails_with :llvm do
    build 2334
  end

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end
end

class Rfcdiff < Formula
  desc "Compare RFC Internet Draft versions"
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.42.tgz"
  sha1 "fc5b40cc262d169d92a8e0454ec1ebaf3444b594"

  bottle do
    cellar :any
    sha1 "d6fe59c07cbbe0ba0d268a5d84691a5720a0d16e" => :yosemite
    sha1 "88884113013f1e061f180aeb2c4b0eaea1919334" => :mavericks
    sha1 "62c13793f7558377afd40fde2aa18b93d96e034e" => :mountain_lion
  end

  depends_on "wdiff"
  depends_on "gawk" => :recommended
  depends_on "txt2man" => :build

  resource "rfc42" do
    url "https://tools.ietf.org/rfc/rfc42.txt"
    sha1 "5d6a73c63f2d69deba3849bcb7f7c8be158a016c"
  end

  resource "rfc43" do
    url "https://tools.ietf.org/rfc/rfc43.txt"
    sha1 "9f4c5dd7b20c4c62c31217b19d93a41054376bd8"
  end

  def install
    # replace hard-coded paths
    inreplace "Makefile.common", "/usr/share/man/man1", man1

    bin.mkpath
    man1.mkpath

    system "make", "-f", "Makefile.common",
                   "tool=rfcdiff",
                   "sources=rfcdiff.pyht",
                   "prefix=#{prefix}",
                   "install"
  end

  test do
    rfcs = %w[rfc42 rfc43]
    rfcs.each { |name| resource(name).stage name }

    system "#{bin}/rfcdiff", *rfcs
  end
end

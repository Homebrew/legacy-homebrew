class Rfcdiff < Formula
  desc "Compare RFC Internet Draft versions"
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.42.tgz"
  sha256 "1ff5f34a007e9219725d9e3d40767aec5e895d9f890085bec554d0e2a4150634"

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
    sha256 "ba2c826790cae67eb7b4f4ff0f8fe608f620d29f789969c06abbc8da696c8e35"
  end

  resource "rfc43" do
    url "https://tools.ietf.org/rfc/rfc43.txt"
    sha256 "b6fc6c8e185ef122f3a2b025f9e66a5f4242bdec789d2e467c07bbcfef4deebb"
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

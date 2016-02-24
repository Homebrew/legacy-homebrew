class Rfcdiff < Formula
  desc "Compare RFC Internet Draft versions"
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.42.tgz"
  sha256 "1ff5f34a007e9219725d9e3d40767aec5e895d9f890085bec554d0e2a4150634"

  bottle do
    cellar :any
    sha256 "590587076415e6d76a0c352a903bee09dda664529fe3b6bb15d3ea825e66d44a" => :yosemite
    sha256 "4a4b87ede364af23c406b53ec20e4729168363513c8ccc455f359bdde5bc120f" => :mavericks
    sha256 "8473a25840800f44a284dc498966abca18cf41687fce0b101982e6dbd89952e4" => :mountain_lion
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

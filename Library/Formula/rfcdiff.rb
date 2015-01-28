class Rfcdiff < Formula
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.41.tgz"
  sha1 "02bcd3bf6078caec001bf677530c97893edf34a1"

  bottle do
    cellar :any
    sha1 "23297713cb69a8e6f0ee50a4fb48ba788c79c11a" => :yosemite
    sha1 "2bc1ebe0ac57a4d7bb7ae98fec2f8c3ff26f8fe6" => :mavericks
    sha1 "6234be51164d3f204fb34cd22046cfd1c5e34c0a" => :mountain_lion
  end

  depends_on "wdiff"
  depends_on "gawk" => :recommended
  depends_on "txt2man" => :build

  # don't use sudo to install rfcdiff (patch sent to upstream)
  patch do
    url "https://gist.githubusercontent.com/bfontaine/76c96e4ebd4c39fe6ba0/raw/3bf592c37dcae7b36080ac7f8dd8bc7b901e9490/0001-Don-t-use-sudo-to-install-rfcdiff.patch"
    sha1 "4f7a83f507b1ffe1602a3900ffb6e2c5ee9eb192"
  end

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

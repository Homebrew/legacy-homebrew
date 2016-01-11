class Syck < Formula
  desc "Extension for reading and writing YAML"
  homepage "https://wiki.github.com/indeyets/syck/"
  url "https://cloud.github.com/downloads/indeyets/syck/syck-0.70.tar.gz"
  sha256 "4c94c472ee8314e0d76eb2cca84f6029dc8fc58bfbc47748d50dcb289fda094e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2270f693ce6e8f0542f7d57dc6c8fcb731a268aee3c75a314523446c68602d6" => :el_capitan
    sha256 "cacc98eb6fab2440d3f69708688cb80b54bd14e5c472b7097ab9e235d5a670d6" => :yosemite
    sha256 "17606e97952cbea53c5649814d0d86c0cc2cdc5893b8063dcb4be8b4606c4f40" => :mavericks
  end

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize # Not parallel safe.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

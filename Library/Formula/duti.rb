class Duti < Formula
  desc "Select default apps for documents and URL schemes on OS X"
  homepage "http://duti.org/"
  head "https://github.com/moretension/duti.git"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha256 "0e71b7398e01aedf9dde0ffe7fd5389cfe82aafae38c078240780e12a445b9fa"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "eb2195e20db6134589edc886a3d0aa183208b18820e32b7270a2f87b0abacb53" => :el_capitan
    sha256 "eef68eab84629af9bc431d643053b492d687b5389807e62b3bddbad87caf4d86" => :yosemite
    sha256 "205e78f2b770b8e377f129afaf85ecdce18a1e6c13ac9f6eb39a620ec729605e" => :mavericks
  end

  depends_on "autoconf" => :build

  # Add hardcoded SDK path for El Capitan. See https://github.com/moretension/duti/pull/13
  if MacOS.version == :el_capitan
    patch do
      url "https://github.com/moretension/duti/pull/13.patch"
      sha256 "5e2d482fe73fe95aea23c25417fdc3815f14724e96e4ac60e5a329424a735388"
    end
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end

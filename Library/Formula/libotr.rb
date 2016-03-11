class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz"
  sha256 "8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5"

  bottle do
    cellar :any
    sha256 "43d7a166cd12b611e7bf15dfa3865d18e573a81a218e2aeb0061d51203ecde39" => :el_capitan
    sha256 "b3f215fd3952f7a97af36500365c3c017f23de107162f4c76b0e48355bd2a358" => :yosemite
    sha256 "12338de29acd18bb5d7a90552e33b1a353ae7de3f10ab0316dfd6bda379d919b" => :mavericks
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.0.tar.gz"
  sha256 "4fdb891940ec89d300190a98f69a9138248dcb8c8d337633fb981b8d0a9cd930"

  bottle do
    cellar :any
    sha1 "e3a4f4ed938279c649562da5f47589cd260876af" => :yosemite
    sha1 "2fddebe58059fe7dcc3bfebd862051c8c7b8f417" => :mavericks
    sha1 "bbd9c6938ade7c5208c472aba7b65581eb9a210b" => :mountain_lion
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

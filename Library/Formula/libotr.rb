class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz"
  sha256 "8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5"

  bottle do
    cellar :any
    sha256 "6a800d4cc2c2239954d45769ee424431f72896a1f1cb41e58dbf84d3273545b8" => :el_capitan
    sha256 "1f494d03865663bf360ae5e652a5bf840f18372a8767b209fc7ebf4f672aabaf" => :yosemite
    sha256 "b5275f230e3524aa4ac19751de474674be9b86f51420ea3725f115e64f703d8b" => :mavericks
    sha256 "8c41ed8fab1897946f9105ba18223d09867c4b383c9889c3ca84c7752a19a71e" => :mountain_lion
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

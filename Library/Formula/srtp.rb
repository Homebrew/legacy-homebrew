class Srtp < Formula
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.2.tar.gz"
  sha256 "86e1efe353397c0751f6bdd709794143bd1b76494412860f16ff2b6d9c304eda"

  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha1 "d2cc4fa21913d1055557ac4546b7be1bf70059bf" => :yosemite
    sha1 "7e8b5b4fcd340a57e181179e25aef3554e663993" => :mavericks
    sha1 "079bb268a4ccd761d073d3b4f0eed0d2411bdcaa" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
  end
end

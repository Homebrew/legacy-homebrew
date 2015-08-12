class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage "https://github.com/pquerna/ctail"
  url "https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz"
  sha256 "864efb235a5d076167277c9f7812ad5678b477ff9a2e927549ffc19ed95fa911"

  bottle do
    cellar :any_skip_relocation
    sha256 "e871b6482648744654b88cace6590eca1e6dd9e6a3d89a57904437f950d0b8e9" => :el_capitan
    sha256 "c054af9816f833035b8922abf3e935bbe563cc841b098569239f7f9e7b5ff499" => :yosemite
    sha256 "dd29c6d94e2ded11aef266f5d50bdb840e8b0b3b23841d41e68aad777754d23b" => :mavericks
    sha256 "dfab40d65950327c679bde97a335779526c58e99f5679f32f95e517a7249e332" => :mountain_lion
  end

  conflicts_with "byobu", :because => "both install `ctail` binaries"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make", "LIBTOOL=glibtool --tag=CC"
    system "make", "install"
  end
end

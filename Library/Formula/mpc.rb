class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "http://www.musicpd.org/clients/mpc/"
  url "http://www.musicpd.org/download/mpc/0/mpc-0.27.tar.gz"
  sha256 "07113c71a21cbd0ea028273baa8e35f23f2a76b94a5c37e16927fdc7c6934463"

  bottle do
    cellar :any
    sha256 "8cc20e2845ff22ed345dcdb1fe018d50e3ceb208193e1a4e7fc414bc5e825a42" => :yosemite
    sha256 "0b2c7bf14d9ca916295e29784d8bc4d75637c86d9bf8d4c59713d54fcc6d9b31" => :mavericks
    sha256 "c80bf07b0a0e3c30cb4d4dd4d4a3da5479c43b9a1be389ed8e164e5e618a8ac3" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end

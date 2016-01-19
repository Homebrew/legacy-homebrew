class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.3.tar.gz"
  sha256 "31a49c43b60e86b3ed731e0a1b988b88d35b755c85d103e93e1507278328bf73"

  bottle do
    cellar :any
    sha256 "3483cb438e816f4a88d9c0f166a73aa40c042e96b49955a9280d42b5d8f65f47" => :el_capitan
    sha256 "9e143d03e6017dd8aa55696e3d5e8f0f0c2e25c6d5fefb496d6fa3cf113e10aa" => :yosemite
    sha256 "804098ab7f9c7ecac5d8749d7b13d542b07dd3551170da17568a073710740ac6" => :mavericks
  end

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unshield -V")
  end
end

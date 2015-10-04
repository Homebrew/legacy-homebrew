class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.3.tar.gz"
  sha256 "31a49c43b60e86b3ed731e0a1b988b88d35b755c85d103e93e1507278328bf73"

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

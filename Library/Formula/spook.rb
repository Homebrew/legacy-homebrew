# Note: pull from git tag to get submodules
class Spook < Formula
  desc "Replacement for Guard, based on LuaJIT, MoonScript, C and libuv"
  homepage "https://github.com/johnae/spook"
  url "https://github.com/johnae/spook.git",
      :tag => "0.5.5",
      :revision => "7d1877eff3c2dd7a7f3fb5a9ad160d38ce84ba39"
  head "https://github.com/johnae/spook.git"

  depends_on "cmake" => :build

  def install
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    bin.install "spook"
  end

  test do
    system bin/"spook", "--version"
  end
end

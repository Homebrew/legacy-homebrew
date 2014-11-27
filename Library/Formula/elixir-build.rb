require "formula"

class ElixirBuild < Formula
  homepage "https://github.com/mururu/elixir-build"
  head "https://github.com/mururu/elixir-build.git"
  url "https://github.com/mururu/elixir-build/archive/v20141001.tar.gz"
  sha1 "12412f1c75924fe1ef3f5bca222616a7db614146"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/elixir-build", "--version"
  end
end

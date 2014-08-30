require "formula"

class ElixirBuild < Formula
  homepage "https://github.com/mururu/elixir-build"
  head "https://github.com/mururu/elixir-build.git"
  url "https://github.com/mururu/elixir-build/archive/v20140421.tar.gz"
  sha1 "844b8e3e05c5606d272e2dca0f92dfac56bb58d5"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/elixir-build", "--version"
  end
end

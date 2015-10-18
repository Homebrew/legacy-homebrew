class ElixirBuild < Formula
  desc "Elixir version of ruby-build"
  homepage "https://github.com/mururu/elixir-build"
  head "https://github.com/mururu/elixir-build.git"
  url "https://github.com/mururu/elixir-build/archive/v20141001.tar.gz"
  sha256 "825637780a580b7ebe8c5265a43d37ceff9f3876e771aa2f824079e504ad7347"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/elixir-build", "--version"
  end
end

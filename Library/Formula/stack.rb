class Stack < Formula
  desc "A cross-platform program for developing Haskell projects."
  homepage "https://github.com/commercialhaskell/stack"
  url "https://github.com/fpco/stack/releases/download/v0.0.0-beta/stack-0.0.0-x86_64-osx.gz"
  sha256 "1b8cd1de81b83fafbdbcf7a72019d278f540f06aa36da9a79185bc8963721beb"

  def install
    mv "stack-0.0.0-x86_64-osx", "stack"
    bin.install "stack"
  end

  test do
    system "stack"
  end
end

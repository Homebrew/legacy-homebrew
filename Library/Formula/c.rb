class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.09.tar.gz"
  sha256 "e22bc962ba4ed9a1d84929670626abf7372271efc9d478899fef9981449382ab"

  def install
    bin.install "c"
  end

  test do
    system "echo \"int main(void){return 0;}\" | #{bin}/c"
  end
end
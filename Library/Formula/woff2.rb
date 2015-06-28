class Woff2 < Formula
  desc "Woff2 compress and decompress by Google"
  homepage "https://github.com/prieb/woff2-homebrew"
  url "https://github.com/prieb/woff2-homebrew.git"
  version "0.2"

  def install
    system "git submodule init"
    system "git submodule update"
    cd "woff2" do
      system "git submodule update"
      system "make clean all"
      bin.install "woff2_compress", "woff2_decompress"
    end
    share.install "tests/OpenSans-Regular.ttf"
  end

  test do
    system "#{bin}/woff2_compress #{share}/OpenSans-Regular.ttf"
  end
end

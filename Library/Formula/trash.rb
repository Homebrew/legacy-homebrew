class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "http://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.8.5.tar.gz"
  sha256 "1e08fdcdeaa216be1aee7bf357295943388d81e62c2c68c30c830ce5c43aae99"

  conflicts_with "osxutils", :because => "both install a trash binary"

  def install
    system "make"
    system "make", "docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  test do
    system "#{bin}/trash"
  end
end

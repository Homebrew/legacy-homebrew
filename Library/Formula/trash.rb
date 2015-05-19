require 'formula'

class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage 'http://hasseg.org/trash/'
  url 'https://github.com/ali-rantakari/trash/archive/v0.8.5.tar.gz'
  sha1 '4e1273a08e7f67f48a8d4aea5119ea733556b8a9'

  conflicts_with 'osxutils', :because => 'both install a trash binary'

  def install
    system "make"
    system "make docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  test do
    system "#{bin}/trash"
  end
end

require 'formula'

class Trash < Formula
  homepage 'http://hasseg.org/trash/'
  url 'https://github.com/ali-rantakari/trash/archive/v0.8.4.tar.gz'
  sha1 'e70ebeba684fd1fd126d912e3528115fbb2fb7be'

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

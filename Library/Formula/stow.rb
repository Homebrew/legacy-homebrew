class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "http://ftpmirror.gnu.org/stow/stow-2.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/stow/stow-2.2.2.tar.gz"
  sha256 "e2f77649301b215b9adbc2f074523bedebad366812690b9dc94457af5cf273df"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf0a55711d83b08953a2de183d20cec481029dc95e9ea2ebd5049bf13ea8e1b" => :el_capitan
    sha256 "4062d438086c6f9e407db818d318ef9d857f7c909bd4730edfc174573f5958d4" => :yosemite
    sha256 "1f8ca6143dacc3cebb3551606b51a982b287c3b2f371010c7b10ca82ce89a393" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end

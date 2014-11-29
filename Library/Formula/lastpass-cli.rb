require "formula"

class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.4.0.tar.gz"
  sha1 "2c5766be2ad5bca398ed7615ddadde9c5bbf0ecd"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha1 "b298283e42b9ee0b59326e57c681c779a22af475" => :yosemite
    sha1 "62957f48f3d11b631fca83055e233af602f23135" => :mavericks
    sha1 "d8ee161aa2f672776d15d2e54e36323c3d322e53" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "pinentry" => :optional

  option "with-doc", "Install man pages"

  if build.with? "doc"
    depends_on "asciidoc" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc" if build.with? "doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end

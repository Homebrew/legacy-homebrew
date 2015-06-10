class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.5.1.tar.gz"
  sha256 "46b8b1e85085f816bd10b12bd3d74cef59ad8b1b4dc7ac9ec67366d8c22f99a6"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "b881d418eb5bd553df3b4743df7487493fee59527f126a76781f9b477af7cc37" => :yosemite
    sha256 "20c359cbc4c4e4cf79c7d7563539578063c6243788715a2b691aec5796e92709" => :mavericks
    sha256 "626b8ca141ee1c798029024ccdacfcad78b71baf1c8ec4c615d7ab16e2c64ebc" => :mountain_lion
  end

  option "with-doc", "Install man pages"

  depends_on "asciidoc" => :build if build.with? "doc"
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc" if build.with? "doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end

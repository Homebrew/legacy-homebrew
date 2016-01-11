class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.8.0.tar.gz"
  sha256 "c5c6076a9a80de275f7fc57275d303cc0c4eb21ff06f705659047abc09a8595b"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "7a06b1f10ee8fae07be4f73eb7f9918236ecc6a678dd57366daf7af33d86477c" => :el_capitan
    sha256 "a9f8e49b31966102cdd13b0356711d44cfed43ed36f3b7739c74cb67cb70a08d" => :yosemite
    sha256 "c27100ba099a88cfcbfa05b7927e1b04b7fce866f298e994d7693dd3b75f9b4e" => :mavericks
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

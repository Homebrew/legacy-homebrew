class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.8.1.tar.gz"
  sha256 "ba845a827501f3c49514e977c8de25e5950d3ea482d7a3c31090148310a83056"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "b57ee688d9e9877f25a0ef566cff9a8c364f28e26c54b3c11eb338468cddfeb2" => :el_capitan
    sha256 "4bd4bc58d9e433ecc229763b44d1b0c29312251fb0cff85a4afb5ca746f48767" => :yosemite
    sha256 "fa6ad38499f5df9c9ac23f70d1a58094532032b35bcca4a23f1659e0f7725782" => :mavericks
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

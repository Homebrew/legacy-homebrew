class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.7.0.tar.gz"
  sha256 "2acfb7723e85442fca4d307ee022526c673d856f5560b6e270828a16e8d2702b"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "bd8ff2b7a1ff211933c1040e0f14e3fc52ffcb66510a0fdd6aa7a3d3d09823e9" => :el_capitan
    sha256 "d790132c4aed1337d8546b15901b37a3024833a226d9c39587f680951c52ddb1" => :yosemite
    sha256 "bfb00a6d1767be9243be4a2fbec1299b5d334bb89abe11c9a6b27b844cf17542" => :mavericks
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

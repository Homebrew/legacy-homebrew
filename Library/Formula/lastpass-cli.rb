require "formula"

class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.4.0.tar.gz"
  sha1 "2c5766be2ad5bca398ed7615ddadde9c5bbf0ecd"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha1 "2dce40ba5321331bdcc1bfe06ae30c3240dcfbd8" => :yosemite
    sha1 "952c4e58291145bc4bcfee02e299787f3f9e4d93" => :mavericks
    sha1 "96f02cd6ce93b14b56a2a75412523624f20cb36e" => :mountain_lion
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

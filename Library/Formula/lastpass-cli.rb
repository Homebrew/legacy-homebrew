class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.6.0.tar.gz"
  sha256 "e48f210b34a030e8b8cef3e1d05957aabe757ea4cd31bf03c46b70ddc830733c"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "7e2cb645b71fc53c029449e68bb5465f8de89a2562e0b9f0f86276f7737039e4" => :el_capitan
    sha256 "536f7edb18689381f00d41ef0327259ac9e76f3751a1c86ceffd8a65adeae5da" => :yosemite
    sha256 "8bc905701865083b3637dbc92a0bcd60d71dc5d61b593dc6a97f9a40d86f5323" => :mavericks
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

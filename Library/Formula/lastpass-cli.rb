class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.8.0.tar.gz"
  sha256 "c5c6076a9a80de275f7fc57275d303cc0c4eb21ff06f705659047abc09a8595b"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "44078a95d2b55b4782546b8732b97a0b853d322e9c000684e303285da661148f" => :el_capitan
    sha256 "13d3c31eca94c393309f421181e5981a0f438fe9cf488b07066504bba4baeffc" => :yosemite
    sha256 "ce94133d8e68a941edf7d0f545a301f3a8a20bbe7421dd9760aec09c4c9db84f" => :mavericks
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

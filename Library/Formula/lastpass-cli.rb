class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.6.0.tar.gz"
  sha256 "e48f210b34a030e8b8cef3e1d05957aabe757ea4cd31bf03c46b70ddc830733c"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "56c3b3a9db9032ad4873d760f5b51ac0d434bda68a5096ab4e89fa15e7b5839b" => :yosemite
    sha256 "235bea0f96d2c65483fe111174e904b0d6029b6e358f25d3cd757edde8a2c5f3" => :mavericks
    sha256 "f09bcd279c1ade1d40b893e8fa34b7072f5cc2da15722669d38a05912725f478" => :mountain_lion
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

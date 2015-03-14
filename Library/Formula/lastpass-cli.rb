class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.5.0.tar.gz"
  sha256 "09e7b1e5c1520db2a34a49e7ae07e5b3a7555a4ed2490ed7b56f047065bca812"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha1 "00b5e1e8dfa6218820407b81deb36e1ed8962add" => :yosemite
    sha1 "c3daa164c62caa821634ebb9ff6a67952d7638fe" => :mavericks
    sha1 "3661870b984015eac001c67d6484a0850b7d6110" => :mountain_lion
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

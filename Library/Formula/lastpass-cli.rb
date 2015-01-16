require "formula"

class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.4.0.tar.gz"
  sha1 "2c5766be2ad5bca398ed7615ddadde9c5bbf0ecd"
  head "https://github.com/lastpass/lastpass-cli.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "00b5e1e8dfa6218820407b81deb36e1ed8962add" => :yosemite
    sha1 "c3daa164c62caa821634ebb9ff6a67952d7638fe" => :mavericks
    sha1 "3661870b984015eac001c67d6484a0850b7d6110" => :mountain_lion
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

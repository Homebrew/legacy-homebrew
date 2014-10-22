require "formula"

class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.3.0.tar.gz"
  sha1 "a4491bc5d258899ead6c64d4f97d23af93e03ff9"

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

require "formula"

class Lpass < Formula
  homepage "https://lastpass.com/"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.3.0.tar.gz"
  sha1 "a4491bc5d258899ead6c64d4f97d23af93e03ff9"

  head "https://github.com/lastpass/lastpass-cli.git"

  depends_on "openssl"
  depends_on "curl"
  depends_on "libxml2"
  depends_on "asciidoc"
  depends_on "xclip"

  def install
    ENV["PREFIX"] = "#{prefix}"

    system "make", "install"
    system "make", "install-doc"
  end

  test do
    system "#{bin}/lpass", "-v"
  end
end

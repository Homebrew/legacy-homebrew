require "formula"

class LastpassCli < Formula
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.3.0.tar.gz"
  sha1 "a4491bc5d258899ead6c64d4f97d23af93e03ff9"

  depends_on 'curl'
  depends_on 'openssl'
  depends_on 'libxml2'
  depends_on 'pinentry' => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # lpass requires user credentials to login. Any commands attempted without
    # a user authorization will fail. The only safe unauthenticated command
    # that returns 0 on exit is unfortunately --version (--help exits with a 1)
    system "#{bin}/lpass", "--version"
  end
end

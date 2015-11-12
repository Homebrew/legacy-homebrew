class Drip < Formula
  desc "JVM launching without the hassle of persistent JVMs"
  homepage "https://github.com/flatland/drip"
  url "https://github.com/flatland/drip/archive/0.2.4.tar.gz"
  sha256 "9ed25e29759a077d02ddac61785f33d1f2e015b74f1fd934890aba4a35b3551d"

  def install
    system "make"
    libexec.install %w[bin src Makefile]
    bin.install_symlink libexec/"bin/drip"
  end
end

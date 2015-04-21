require 'formula'

class Smake < Formula
  homepage "http://s-make.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/s-make/smake-1.2.5.tar.bz2"
  sha256 "27566aa731a400c791cd95361cc755288b44ff659fa879933d4ea35d052259d4"

  bottle do
    sha1 "30e72ed47a18ce5c90107cc45ac8b603b508169f" => :yosemite
    sha1 "6883bca2c7c13db1139234f73ef387f6a311fbcd" => :mavericks
    sha1 "709ab7a8011da3b92d61db6aa9eef3c7fbc1b9e7" => :mountain_lion
  end

  # A sed operation silently fails on Lion or older, due
  # to some locale settings in smake's build files. The sed
  # wrapper on 10.8+ overrides them.
  env :std if MacOS.version <= :lion

  def install
    ENV.deparallelize # the bootstrap smake does not like -j

    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{libexec}", "INS_RBASE=#{libexec}", "install"
    bin.install_symlink libexec/"bin/smake"
    man1.install_symlink Dir["#{libexec}/share/man/man1/*.1"]
    man5.install_symlink Dir["#{libexec}/share/man/man5/*.5"]
  end

  test do
    system "#{bin}/smake", "-version"
  end
end

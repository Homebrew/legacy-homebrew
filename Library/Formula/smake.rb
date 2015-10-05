class Smake < Formula
  desc "Portable make program with automake features"
  homepage "http://s-make.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/s-make/smake-1.2.5.tar.bz2"
  sha256 "27566aa731a400c791cd95361cc755288b44ff659fa879933d4ea35d052259d4"

  bottle do
    sha256 "a5cb6ea4fab2d0ce67342f482fd0efb4dcc20483722e56ae120880d2a97ebab0" => :el_capitan
    sha256 "c1420a59ceba43481eac2b2046a7d3c4aac967a12ff52bccb3b4697eca8d5c8f" => :yosemite
    sha256 "4e8157c27f8ab0d5ad2c9673a86357f38acfabea1ac4eef80c54e8141dfdb336" => :mavericks
    sha256 "ce1edbcc0ec3f7db2208e39a09183d7dcfa21d50250393f5ad5c83204ab7b3ed" => :mountain_lion
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

require "formula"

class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.10.tar.gz"
  sha1 "e24e4a12d41a98c3eaa7558a47cc899bd6b1051a"

  head "https://github.com/tokuhirom/perl-build.git"

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end

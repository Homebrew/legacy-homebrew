class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.10.tar.gz"
  sha256 "f005a730ee32b5dfc79af662f0862b31f078606ae3e78986b4be359a1e5e2bb9"

  head "https://github.com/tokuhirom/perl-build.git"

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end

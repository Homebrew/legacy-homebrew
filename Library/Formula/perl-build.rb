class PerlBuild < Formula
  desc "Perl builder"
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.12.tar.gz"
  sha256 "2a3c33b7ea63c511db20778ebcedc35a0cc53fb780fc61b23d48ef3cc216bfc8"

  head "https://github.com/tokuhirom/perl-build.git"

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end

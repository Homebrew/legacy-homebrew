require 'formula'

class Mdr < Formula
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.0.tar.gz"
  sha1 "4e2424363aa72f7e94997c91594f1f1c7901587d"

  def install
    system "rake"
    system "rake", "release"
    libexec.install Dir['release/*']
    bin.install_symlink libexec+'mdr'
  end
end

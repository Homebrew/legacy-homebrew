class G2 < Formula
  desc "Friendly git client"
  homepage "https://orefalo.github.io/g2/"
  url "https://github.com/orefalo/g2/archive/v1.1.tar.gz"
  sha256 "bc534a4cb97be200ba4e3cc27510d8739382bb4c574e3cf121f157c6415bdfba"

  head "https://github.com/orefalo/g2.git"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    To complete the installation:
      . #{prefix}/g2-install.sh

    NOTE: This will install a new ~/.gitconfig, backing up any existing
    file first. For more information view:
      #{prefix}/README.md
    EOS
  end
end

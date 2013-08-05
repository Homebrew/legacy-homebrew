require 'formula'

class G2 < Formula
  homepage 'http://orefalo.github.io/g2/'
  url 'https://github.com/orefalo/g2/archive/v1.1.tar.gz'
  sha1 'e225d21623e6884a9e99a92f43cdd750068ad211'

  head 'https://github.com/orefalo/g2.git'

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

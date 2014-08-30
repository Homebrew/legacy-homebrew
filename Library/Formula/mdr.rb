require 'formula'

class Mdr < Formula
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.0.tar.gz"
  sha1 "4e2424363aa72f7e94997c91594f1f1c7901587d"

  bottle do
    cellar :any
    sha1 "7e65ce807ef58e0e927020608f7b564202f78cce" => :mavericks
    sha1 "aee5991938fd9da31c73404d3eff3bf9ce83d4f7" => :mountain_lion
    sha1 "ddb745e21b318a2bb37b50dab7ca77df167dc8c2" => :lion
  end

  def install
    system "rake"
    libexec.install Dir["*"]
    bin.install_symlink libexec+'mdr'
  end
end

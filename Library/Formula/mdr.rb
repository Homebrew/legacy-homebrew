class Mdr < Formula
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.1.tar.gz"
  sha1 "dbadda07e8ee7baaa1a3d6c82cbae8434b8327d5"

  bottle do
    cellar :any
    sha1 "7e65ce807ef58e0e927020608f7b564202f78cce" => :mavericks
    sha1 "aee5991938fd9da31c73404d3eff3bf9ce83d4f7" => :mountain_lion
    sha1 "ddb745e21b318a2bb37b50dab7ca77df167dc8c2" => :lion
  end

  def install
    system "rake"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"build/dev/mdr"
  end

  test do
    system "#{bin}/mdr", "-h"
  end
end

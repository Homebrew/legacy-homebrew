class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/0.7.0.tar.gz"
  sha256 "0688fe4c13c65c6fa90989c57c04fafe34114889d2d100b6e62538e8f2b0dc02"

  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9b7742de26a901cf873a9829c443443f3f06a3ada26aaa3d56e7b800b8f481fa" => :el_capitan
    sha256 "f4e97a9cab7626785cf3c60a64746d187e89dec23e2f3cb1de29c5f8ae2a8b47" => :yosemite
    sha256 "33ef64eb73b8748c18a0760ced72ddef026bd08b9fc06910f13565d0954826e2" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
    # completion hasn't been released in a tagged stable version yet
    if build.head?
      bash_completion.install "git-imerge.bashcomplete"
    end
  end

  test do
    system "#{bin}/git-imerge", "-h"
  end
end

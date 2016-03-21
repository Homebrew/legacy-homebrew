class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20160123", :revision => "6cd6c0ced619695cdede1fb6b0d654acee1bceb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0196ab03a5b69fa59d0a062f41556d52514d92a375e9a47ca820ac11942e531" => :el_capitan
    sha256 "b8a9ca76ef1c039ba966d6475c210b1e4a110915d66d61004753d34c1558954b" => :yosemite
    sha256 "929175b5237dc1d2319f51da2f665a0cfcbdbdad67633db9c01c5e69ee3e6183" => :mavericks
  end

  resource("test-repo") do
    url "https://github.com/Homebrew/homebrew-command-not-found.git"
  end

  def install
    system "make"
    bin.install "mr", "webcheckout"
    man1.install gzip("mr.1", "webcheckout.1")
    (share/"mr").install Dir["lib/*"]
  end

  test do
    resource("test-repo").stage do
      system bin/"mr", "register"
      assert_match(/^mr status: #{Dir.pwd}$/, shell_output("#{bin}/mr status"))
    end
  end
end

class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20150503", :revision => "073a3b517580bcd2236bf9d36beff18c1222e8aa"

  bottle do
    cellar :any
    sha256 "e0afd82b9ce781ceb404831e1ee068e69b7f09a0d38e79a8c8050d6970bc1ae1" => :yosemite
    sha256 "bba106fbbd96d7ba29f89efd9d4f73a899cce76777a34c92438da03e8883c75e" => :mavericks
    sha256 "06e4131b245b49510d74d0f5da3125d107a45dd8f8a54544eda2e1e50a908e6d" => :mountain_lion
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

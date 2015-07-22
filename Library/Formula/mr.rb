class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "http://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20150503", :revision => "073a3b517580bcd2236bf9d36beff18c1222e8aa"

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

class Bzrtools < Formula
  desc "Bazaar plugin that supplies useful additional utilities"
  homepage "https://launchpad.net/bzrtools"
  url "https://launchpad.net/bzrtools/trunk/2.3.0/+download/bzrtools-2.3.0.tar.gz"
  sha256 "706270db274cdb4897eda1b8bb412383c71f6d1b3fac6ae3db587ac249ad5b79"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bzrtools").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "sample"
    system "bzr", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"

    cd "sample/trunk" do
      msg = "my commit"
      system "bzr", "add", "test.txt"
      system "bzr", "commit", "-m", msg
      assert_match msg, shell_output("bzr heads")
    end
  end
end

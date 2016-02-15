class BzrExternals < Formula
  desc "Bazaar support for external branches like svn:externals"
  homepage "https://launchpad.net/bzr-externals"
  url "https://launchpad.net/bzr-externals/trunk/1.3.3/+download/bzr-externals-1.3.3.tar.gz"
  sha256 "4ee33852f415cd5a982c4fa0bb548f86f2ae52368407c3e8d03d55bcfd7f3332"

  bottle :unneeded
  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/externals").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"

    system "bzr", "init", "project1"
    cd "project1" do
      touch "readme1.txt"
      system "bzr", "add"
      system "bzr", "commit", "-m", "setup project1"
    end

    system "bzr", "init", "project2"
    cd "project2" do
      touch "readme1.txt"
      system "bzr", "branch", "../project1", "subproject"
      mkdir ".bzrmeta"
      (testpath/"project2/.bzrmeta/externals").write("../project1 subproject 1")
      system "bzr", "add"
      system "bzr", "commit", "-m", "setup project2"
    end

    system "bzr", "branch", "project2", "project3"
    cd "project3" do
      assert_match(/setup project2/, shell_output("bzr log"))
      cd "subproject" do
        assert_match(/setup project1/, shell_output("bzr log"))
      end
    end
  end
end

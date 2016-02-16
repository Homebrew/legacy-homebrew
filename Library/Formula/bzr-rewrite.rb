class BzrRewrite < Formula
  desc "Bazaar plugin to support rewriting revisions and rebasing"
  homepage "https://launchpad.net/bzr-rewrite"
  url "https://launchpad.net/bzr-rewrite/trunk/0.6.3/+download/bzr-rewrite-0.6.3.tar.gz"
  sha256 "f4d0032a41a549a0bc3ac4248cd4599da859174ea33e56befcb095dd2c930794"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/rewrite").install Dir["*"]
  end

  test do
    file_path1 = (testpath/"foo/trunk/file1.txt").to_s
    file_path2 = (testpath/"foo/b1/file2.txt").to_s

    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "foo"

    cd "foo" do
      system "bzr", "init", "trunk"
      cd "trunk" do
        open(file_path1, "w") { |f| f.puts "change" }
        system "bzr", "add"
        system "bzr", "commit", "-m", "trunk 1"
      end

      system "bzr", "branch", "trunk", "b1"
      cd "b1" do
        open(file_path2, "w") { |f| f.puts "change" }
        system "bzr", "add"
        system "bzr", "commit", "-m", "branch 1"

        open(file_path2, "a") { |f| f.puts "change" }
        system "bzr", "commit", "-m", "branch 2"
      end

      cd "trunk" do
        open(file_path1, "a") { |f| f.puts "change" }
        system "bzr", "commit", "-m", "trunk 2"

        open(file_path1, "a") { |f| f.puts "change" }
        system "bzr", "commit", "-m", "trunk 3"
      end

      cd "b1" do
        system "bzr", "rebase", "../trunk"

        assert_match(/branch 2/, shell_output("bzr log -r5"))
        assert_match(/branch 1/, shell_output("bzr log -r4"))
        assert_match(/trunk 3/,  shell_output("bzr log -r3"))
        assert_match(/trunk 2/,  shell_output("bzr log -r2"))
        assert_match(/trunk 1/,  shell_output("bzr log -r1"))
      end
    end
  end
end

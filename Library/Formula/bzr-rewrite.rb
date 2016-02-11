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
    edit_file1 = "echo \"change\" >> file1.txt"
    edit_file2 = "echo \"change\" >> file2.txt"

    # Create repo
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "foo"

    cd "foo" do
      # Create trunk branch with inital commit
      system "bzr", "init", "trunk"
      cd "trunk" do
        system edit_file1
        system "bzr", "add"
        system "bzr", "commit", "-m", "trunk 1"
      end

      # Create b1 branch from trunk, adding two commits
      system "bzr", "branch", "trunk", "b1"
      cd "b1" do
        system edit_file2
        system "bzr", "add"
        system "bzr", "commit", "-m", "branch 1"

        system edit_file2
        system "bzr", "commit", "-m", "branch 2"
      end

      # Switch to trunk and add two additional commits causing branches to diverge
      cd "trunk" do
        system edit_file1
        system "bzr", "commit", "-m", "trunk 2"

        system edit_file1
        system "bzr", "commit", "-m", "trunk 3"
      end

      # Rebase b1 onto tip of trunk
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

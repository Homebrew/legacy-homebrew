class BzrColo < Formula
  desc "Git style colocated branches for Bazaar"
  homepage "https://launchpad.net/bzr-colo"
  url "https://launchpad.net/bzr-colo/trunk/0.4.0/+download/bzr-colo-0.4.0.tar.gz"
  sha256 "f61c1abaf80f1e4a573fefd492b70938d27c4b8ca5611cdb0e0a4dc0ed71bbb3"

  bottle :unneeded
  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/colo").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "colo-init", "foo"
    file_path = (testpath/"foo/trunk/foo.txt")

    cd "foo" do
      system "bzr", "colo-checkout", "trunk"

      cd "trunk" do
        file_path.write("change")
        system "bzr", "add"
        system "bzr", "commit", "-m", "some change in trunk"

        system "bzr", "colo-branch", "branch1"
        assert_match(/\* branch1/, shell_output("bzr colo-branches"))

        file_path.open("a") { |f| f.puts "change" }
        system "bzr", "commit", "-m", "some change in branch1"
        assert_match(/some change in branch1/, shell_output("bzr log -l1"))

        system "bzr", "switch", "colo:trunk"
        assert_match(/\* trunk/, shell_output("bzr colo-branches"))
        assert_match(/some change in trunk/, shell_output("bzr log -l1"))

        system "bzr", "merge", "colo:branch1"
        system "bzr", "commit", "-m", "this is so much worse than just using bzr"
        assert_match(/this is so much worse than just using bzr/, shell_output("bzr log -r2"))
        assert_match(/some change in trunk/, shell_output("bzr log -r1"))
      end
    end
  end
end

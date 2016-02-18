class BzrBisect < Formula
  desc "Bisection support for Bazaar"
  homepage "https://launchpad.net/bzr-bisect"
  url "lp:bzr-bisect", :using => :bzr, :revision => "jelmer@samba.org-20120803130348-l0ydx0dn94f1xrjr"
  version "jelmer@samba.org-20120803130348-l0ydx0dn94f1xrjr"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bisect").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init", "foo"
    file_path = (testpath/"foo/foo.txt").to_s

    cd "foo" do
      open(file_path, "w") { |f| f.puts "change" }
      system "bzr", "add"
      system "bzr", "commit", "-m", "change 1"

      open(file_path, "a") { |f| f.puts "change" }
      system "bzr", "commit", "-m", "change 2"

      open(file_path, "a") { |f| f.puts "change" }
      system "bzr", "commit", "-m", "change 3"

      open(file_path, "a") { |f| f.puts "change" }
      system "bzr", "commit", "-m", "change 4"

      open(file_path, "a") { |f| f.puts "change" }
      system "bzr", "commit", "-m", "change 5"

      system "bzr", "bisect", "start"

      assert_match(/On revision 2/, shell_output("bzr bisect yes"))
      assert_match(/On revision 1/, shell_output("bzr bisect yes"))
      assert_match(/On revision 1/, shell_output("bzr bisect no"))

      system "bzr", "bisect", "reset"
    end
  end
end

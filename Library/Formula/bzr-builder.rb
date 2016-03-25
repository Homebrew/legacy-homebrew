class BzrBuilder < Formula
  desc "Bazaar plugin to construct a branch based on a recipe"
  homepage "https://launchpad.net/bzr-builder"
  url "https://launchpad.net/bzr-builder/trunk/0.7.3/+download/bzr-builder-0.7.3.tar.gz"
  sha256 "9f8a078eafd6700ccbefa4e7e3f7df3240e15a2003c9538135c4be945ac90c91"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/builder").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "repo"

    cd "repo" do
      system "bzr", "init", "trunk"

      cd "trunk" do
        touch "readme.txt"
        system "bzr", "add"
        system "bzr", "commit", "-m", "initial import"
      end

      (testpath/"repo/my.recipe").write <<-EOS.undent
        # bzr-builder format 0.3 deb-version 1.0+{revno}-{revno:packaging}
        trunk
      EOS

      system "bzr", "build", "my.recipe", "branch"

      cd "branch" do
        assert (testpath/"repo/branch/bzr-builder.manifest").exist?
        assert (testpath/"repo/branch/readme.txt").exist?
      end
    end
  end
end

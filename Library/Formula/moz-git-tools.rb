class MozGitTools < Formula
  desc "Tools for working with Git at Mozilla"
  homepage "https://github.com/mozilla/moz-git-tools"
  url "https://github.com/mozilla/moz-git-tools.git",
    :tag => "v0.1", :revision => "cfe890e6f81745c8b093b20a3dc22d28f9fc0032"
  head "https://github.com/mozilla/moz-git-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ddb2e842a6fb26ba5feacdee6bac287d94732abd888bd11bc5c80be4f100a4" => :el_capitan
    sha256 "91f89ec1014d6c7b395571210c0f21b1e701f4bfb90540a94fa3daafd4472d3b" => :yosemite
    sha256 "8df4c14355c7b6291964609122f8643f61d77e05c2b6b68517710e5653a1423e" => :mavericks
  end

  def install
    # Install all the executables, except git-root since that conflicts with git-extras
    bin_array = Dir.glob("git*").push("hg-patch-to-git-patch")
    bin_array.delete("git-root")
    bin_array.delete("git-bz-moz") # a directory, not an executable
    bin_array.each { |e| bin.install e }
  end

  def caveats
    <<-EOS.undent
    git-root was not installed because it conflicts with the version provided by git-extras.
    EOS
  end

  test do
    # create a Git repo and check its branchname
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    (testpath/"myfile").write("my file")
    system "git", "add", "myfile"
    system "git", "commit", "-m", "test"
    assert_match /master/, shell_output("#{bin}/git-branchname")
  end
end

class RbenvBundleExec < Formula
  desc "Integrate rbenv and bundler"
  homepage "https://github.com/maljub01/rbenv-bundle-exec"
  url "https://github.com/maljub01/rbenv-bundle-exec/archive/v1.0.0.tar.gz"
  sha1 "2094ce0ac8f53b500f35a1a1b47a654a42611a35"

  head "https://github.com/maljub01/rbenv-bundle-exec.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks exec").include? "bundle-exec.bash"
  end
end

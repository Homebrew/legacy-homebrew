class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/0.99.tar.gz"
  sha256 "4d5a0224b5050e5573ad42965182d391a6927553560d1953c56f4adf82a64e97"
  head "https://github.com/carsomyr/rbenv-bundler.git"

  bottle :unneeded

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundler.bash", shell_output("rbenv hooks exec")
  end
end

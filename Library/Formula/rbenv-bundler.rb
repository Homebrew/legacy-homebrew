class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/0.99.tar.gz"
  sha1 "21dd20ee363d8b8c0807e659ffa2d572c67848b5"
  head "https://github.com/carsomyr/rbenv-bundler.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks exec").include? "bundler.bash"
  end
end

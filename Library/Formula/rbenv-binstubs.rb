class RbenvBinstubs < Formula
  desc "Make rbenv aware of bundler binstubs"
  homepage "https://github.com/ianheggie/rbenv-binstubs"
  url "https://github.com/ianheggie/rbenv-binstubs/archive/v1.4.tar.gz"
  sha256 "2d8fcb626d1ff47dc490d459999b5779802c3a0b0a319fd33750d63590beacb6"

  head "https://github.com/ianheggie/rbenv-binstubs.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks exec").include? "rbenv-binstubs.bash"
  end
end

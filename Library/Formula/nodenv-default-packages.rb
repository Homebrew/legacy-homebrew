class NodenvDefaultPackages < Formula
  desc "Auto-installs packages for Node installs"
  homepage "https://github.com/jawshooah/nodenv-default-packages"
  url "https://github.com/jawshooah/nodenv-default-packages/archive/0.1.0.tar.gz"
  sha256 "645a60340f4d498c656740bddf480e2cc079b8d371800458c5dc8a92c8909890"
  head "https://github.com/jawshooah/nodenv-default-packages.git"

  depends_on "nodenv"
  depends_on "node-build"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match /default-packages\.bash/, shell_output("nodenv hooks install")
  end
end

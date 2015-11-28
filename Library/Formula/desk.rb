class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/v0.3.1.tar.gz"
  sha256 "b687e2cfa742f763d689391f67a5b5225324e282a0fed100487b1570988d7758"

  bottle :unneeded

  def install
    bin.install "desk"
    bash_completion.install "completions/bash/desk"
    zsh_completion.install "completions/zsh/_desk"
  end

  test do
    (testpath/".desk/desks/test-desk.sh").write("#\n# Description: A test desk\n#")
    list = pipe_output("#{bin}/desk list")
    assert_match /test-desk/, list
    assert_match /A test desk/, list
  end
end

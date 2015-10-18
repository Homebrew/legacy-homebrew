class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/1.0.4.tar.gz"
  sha256 "243e4c2710b92ae722a74470305ea5d2c326c396330dcb2ccbce33bf690e4dfc"

  def install
    bin.install "gibo"
    bash_completion.install "gibo-completion.bash"
    zsh_completion.install "gibo-completion.zsh" => "_gibo"
  end
end

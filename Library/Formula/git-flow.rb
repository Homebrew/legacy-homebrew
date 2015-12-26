class GitFlow < Formula
  desc "Extensions to follow Vincent Driessen's branching model"
  homepage "https://github.com/nvie/gitflow"

  stable do
    # Use the tag instead of the tarball to get submodules
    url "https://github.com/nvie/gitflow.git",
      :tag => "0.4.1",
      :revision => "1ffb6b1091f05466d3cd27f2da9c532a38586ed5"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion/archive/0.4.2.2.tar.gz"
      sha256 "1e82d039596c0e73bfc8c59d945ded34e4fce777d9b9bb45c3586ee539048ab9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "56826b30d91ffb54829f4792f88c673b1c3e748aa662bef5806e4a6f5d0ee015" => :el_capitan
    sha256 "a5e97d4d5c082194b36c18e7b051c43b2d5b37366b2ac56c5ea9407f6315685b" => :yosemite
    sha256 "8e931605a0d12cffa282db7244e0041cc14f8a7692e184a6bc1975800be2dac0" => :mavericks
    sha256 "1ed5c8b915583801fb955e890b758c6d619f8403801dd61c2976a1da314ce5f5" => :mountain_lion
  end

  head do
    url "https://github.com/nvie/gitflow.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion.git", :branch => "develop"
    end
  end

  conflicts_with "git-flow-avh"

  def install
    system "make", "prefix=#{libexec}", "install"
    bin.write_exec_script libexec/"bin/git-flow"

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end

  test do
    system "git", "flow", "init", "-d"
    assert_equal "develop", shell_output("git rev-parse --abbrev-ref HEAD").strip
  end
end

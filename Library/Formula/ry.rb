class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"

  head "https://github.com/jayferd/ry.git"

  bottle do
    cellar :any
    sha256 "81b21b5a615197eddf8048c3cbe21dfd0425ea7fe8fdd3d01f8ab5af487b57a4" => :mavericks
    sha256 "1a7ee174b349b62c9c6192ebb7db6ed741dd1b88261fd2e23f43d53a9a5c2709" => :mountain_lion
    sha256 "a62486fac22e1f2881872653ae7030e64c64e4ecc1cacab4ce0ffd3e3f4c7a80" => :lion
  end

  depends_on "ruby-build" => :recommended
  depends_on "bash-completion" => :recommended

  def install
    ENV["PREFIX"] = prefix
    ENV["BASH_COMPLETIONS_DIR"] = etc/"bash_completion.d"
    ENV["ZSH_COMPLETIONS_DIR"] = share/"zsh/site-functions"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Please add to your profile:
      which ry &>/dev/null && eval "$(ry setup)"

    If you want your Rubies to persist across updates you
    should set the `RY_RUBIES` variable in your profile, i.e.
      export RY_RUBIES="#{HOMEBREW_PREFIX}/var/ry/rubies"
  EOS
  end

  test do
    ENV["RY_RUBIES"] = testpath/"rubies"

    system bin/"ry", "ls"
    assert File.exist?(testpath/"rubies")
  end
end

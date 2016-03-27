class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh."
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/v0.3.1.tar.gz"
  sha256 "f407454f90c560cbc34e7130d39aa88f739d62bba5a431e5f91a2a2aad37758f"

  def install
    pkgshare.install "zsh-autosuggestions.zsh"
  end

  def caveats
    <<-EOS.undent
    To activate the autosuggestions, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc
    EOS
  end

  test do
    assert_match "default",
      shell_output("zsh -c '. #{pkgshare}/zsh-autosuggestions.zsh && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end

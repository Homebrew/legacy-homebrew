class Powerline < Formula
  desc "statusline plugin for vim, and provides statuslines & prompts"
  homepage "https://github.com/powerline/powerline"
  url "https://github.com/powerline/powerline/archive/2.3.tar.gz"
  sha256 "c65762df4733afed585af722978d24bc555fbbabb8ae707e4e525dff6412de5f"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/powerline", "--help"
  end
end

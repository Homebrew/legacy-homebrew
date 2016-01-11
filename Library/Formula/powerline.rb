class Powerline < Formula
  desc "statusline plugin for vim, and provides statuslines & prompts"
  homepage "https://github.com/powerline/powerline"
  url "https://github.com/powerline/powerline/archive/2.3.tar.gz"
  sha256 "c65762df4733afed585af722978d24bc555fbbabb8ae707e4e525dff6412de5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "40f105e9571a23d78d26c30b5562081c1804a20a54bf162ed013ba76b0b3cccf" => :el_capitan
    sha256 "753dc2345d95c924f36c012f9fd72c1b2f72defe9df7a2485145b025b3ac2fa7" => :yosemite
    sha256 "7b56d3e45382da9c2519fb034a48b169458a6cfb188c56678734e4eeb0124348" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/powerline", "--help"
  end
end

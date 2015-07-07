class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.2.tar.gz"
  sha256 "5c8804933dd395ec79e957c96179bf6ac20af24066928685a713e54f44107a2c"
  head "https://github.com/cask/cask.git"

  bottle do
    cellar :any
    sha256 "68b9e9f496dabaf85bdbef1414679bb5cbd5531383db02ab625d7bab454b6a78" => :yosemite
    sha256 "b8bb1e95119383cb7fa3e22eea1d73cafd77cadcc8fff32b22414115b24faabc" => :mavericks
    sha256 "2a9c3376bc81daa443d7b9a10043e871f7439eb8d11ae2523b18ca0cf11e3832" => :mountain_lion
  end

  depends_on :emacs => "23"

  def install
    zsh_completion.install "etc/cask_completion.zsh"
    bin.install "bin/cask"
    prefix.install Dir["*.el"]
    prefix.install "templates"
    (share/"emacs/site-lisp").install_symlink "#{prefix}/cask-bootstrap.el"
    (share/"emacs/site-lisp").install_symlink "#{prefix}/cask.el"
    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'cask)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

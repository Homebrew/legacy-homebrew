class Cask < Formula
  homepage "http://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.2.tar.gz"
  sha256 "5c8804933dd395ec79e957c96179bf6ac20af24066928685a713e54f44107a2c"
  head "https://github.com/cask/cask.git"

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

class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.3.tar.gz"
  sha256 "661c15e63c0e8240033ec67f4333337db97178ad5b9bb36fa3dbd411e9196813"
  head "https://github.com/cask/cask.git"

  bottle :unneeded

  depends_on :emacs => ["24", :run]

  def install
    bin.install "bin/cask"
    prefix.install "templates"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    (share/"emacs/site-lisp/cask").install_symlink "#{prefix}/cask.el"
    (share/"emacs/site-lisp/cask").install_symlink "#{prefix}/cask-bootstrap.el"

    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/cask")
      (require 'cask)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

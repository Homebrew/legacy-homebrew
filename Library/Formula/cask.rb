class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.2.tar.gz"
  sha256 "5c8804933dd395ec79e957c96179bf6ac20af24066928685a713e54f44107a2c"
  head "https://github.com/cask/cask.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "0aa6408deec257c837b2e82b6971a3a0d0ab2c839e7a918c1d72c951e307f223" => :yosemite
    sha256 "01a2665ec170894ae6c52cfea441743e5c61c2f62272852814bf2e932c2c11a2" => :mavericks
    sha256 "587bed663534d0bec5ea0af10cc5a0bd5b9bda9a1178ea03706260849b089a32" => :mountain_lion
  end

  depends_on :emacs => ["24", :run]

  def install
    bin.install "bin/cask"
    prefix.install "templates"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    (share/"emacs/site-lisp/cask").install_symlink "#{prefix}/cask.el"
    (share/"emacs/site-lisp/cask").install_symlink "#{prefix}/cask-bootstrap.el"
    zsh_completion.install "etc/cask_completion.zsh"

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

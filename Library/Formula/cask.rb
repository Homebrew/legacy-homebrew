class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.2.tar.gz"
  sha256 "5c8804933dd395ec79e957c96179bf6ac20af24066928685a713e54f44107a2c"
  head "https://github.com/cask/cask.git"
  revision 1

  bottle do
    cellar :any
    sha256 "dbe1031ea0043666e49f923982676305b0534323c5ce7e347369d641a33720f1" => :yosemite
    sha256 "7b4d7cde97d91b2b457f093b63095f9ba14b0d1dc22d45c96dd95b656878eff6" => :mavericks
    sha256 "8262e37f32afc254ff6a25baabaa48537961bec0094e5b01aae73a9cc4baf87c" => :mountain_lion
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

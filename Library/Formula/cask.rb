class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.4.tar.gz"
  sha256 "b183ea1c50fc215c9040f402b758ecc335901fbc2c3afd4a7302386c888d437d"
  head "https://github.com/cask/cask.git"

  bottle :unneeded

  depends_on :emacs => ["24", :run]

  def install
    bin.install "bin/cask"
    prefix.install "templates"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    elisp.install_symlink "#{prefix}/cask.el"
    elisp.install_symlink "#{prefix}/cask-bootstrap.el"

    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end

  test do
    (testpath/"Cask").write <<-EOS.undent
      (source gnu)
      (depends-on "chess")
    EOS
    system bin/"cask", "install"
    (testpath/".cask").directory?
  end
end

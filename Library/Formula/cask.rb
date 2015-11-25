class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.7.4.tar.gz"
  sha256 "b183ea1c50fc215c9040f402b758ecc335901fbc2c3afd4a7302386c888d437d"
  head "https://github.com/cask/cask.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "32e91615a10deee8354fabd4c71a44bebde3520c16fe1ed10d437b126b0453e2" => :el_capitan
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

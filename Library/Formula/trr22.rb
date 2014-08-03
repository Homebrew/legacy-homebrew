require "formula"

class Trr22 < Formula
  homepage "https://github.com/greeeenkew/homebrew-trr"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  sha1 "17082cc5fcebb8c877e6a17f87800fecc3940f24"

  depends_on "nkf"
  depends_on "apel"

  def install
    system "make", "clean"
    system "make", "all"
    system "sudo", "make", "install"

    system "mkdir -p ~/.emacs.d"
    system "if test -e ~/.emacs.d/init.el
    then
        sed -i -e \"/(autoload 'trr/d\" ~/.emacs.d/init.el
    else
        touch ~/.emacs.d/init.el
    fi"
    system "echo \"(add-to-list 'load-path \\\"/usr/local/share/emacs/site-lisp\\\")\" >> ~/.emacs.d/init.el"
    system "echo \"(autoload 'trr \\\"/usr/local/share/emacs/site-lisp/trr\\\" nil t)\" >> ~/.emacs.d/init.el"
    system "sudo nkf -w --overwrite /usr/local/trr/CONTENTS"

  end

  def caveats
      msg = <<-EOF.undent
      By doing \"M-x trr\" in emacs, you can start trr
      EOF
  end

end

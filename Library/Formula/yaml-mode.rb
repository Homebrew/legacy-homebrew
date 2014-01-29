require "formula"

class YamlMode < Formula
  homepage "https://github.com/yoshiki/yaml-mode"
  url "https://github.com/yoshiki/yaml-mode/archive/release-0.0.9.zip"
  sha1 "d185aaa2d6a0ada9c42c2aba8ac31af25957ef28"

  def site_lisp
    share + "emacs" + "site-lisp"
  end

  def install
    site_lisp.mkpath
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    To use yaml-mode, add the following to your ~/.emacs or ~/.emacs.d/init.el:

        (autoload 'yaml-mode "yaml-mode" "Major mode for editing Yaml files" t)
        (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
        (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

    If you are not using the homebrew version of emacs under #{HOMEBREW_PREFIX}
    then you also need to add the following:

        (add-to-list 'load-path "#{site_lisp}")

    EOS
  end
end

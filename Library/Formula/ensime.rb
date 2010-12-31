require 'formula'

class Ensime <Formula
  url 'https://github.com/downloads/aemoncannon/ensime/ensime_2.8.1-0.4.tar.gz'
  homepage 'http://ensime.blogspot.com'
  md5 'b51f3dcd5ddac40cd472762ac2986416'
  version '0.4'

  def install
    libexec.install Dir['*']    
  end

  def caveats
    <<-EOS.undent
      To use with ENSIME TextMate Bundle, you should set the environment variable
      ENSIME_HOME in TextMate to "#{libexec}"

      To use with Emacs, you should add the following to your .emacs file:
        ;; Load the ensime lisp code...
        (add-to-list 'load-path "#{libexec}/elisp/")
        (require 'ensime)

        ;; This step causes the ensime-mode to be started whenever
        ;; scala-mode is started for a buffer. You may have to customize this step
        ;; if you're not using the standard scala mode.
        (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
    EOS
  end

end

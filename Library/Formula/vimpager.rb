require 'formula'

class Vimpager < Formula
  homepage 'http://www.vim.org/scripts/script.php?script_id=1723'
  url 'http://www.vim.org/scripts/download_script.php?src_id=15255'
  version '1.4.3'
  sha1 '9fada08a4f47a851e0919b4fb98dda6212b8c8eb'

  def install
    bin.install 'download_script.php?src_id=15255' => 'vimpager'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end

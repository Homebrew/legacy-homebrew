require 'formula'

class Vimpager < Formula
  url 'http://www.vim.org/scripts/download_script.php?src_id=14694'
  version '1.4'
  homepage 'http://www.vim.org/scripts/script.php?script_id=1723'
  md5 'b2c4c978c826876e11bf5453eb19c2a7'

  def install
    bin.install 'download_script.php?src_id=14694' => 'vimpager'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end

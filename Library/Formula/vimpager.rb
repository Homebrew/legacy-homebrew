require 'formula'

class Vimpager < Formula
  url 'http://www.vim.org/scripts/download_script.php?src_id=13024'
  version '1.3'
  homepage 'http://www.vim.org/scripts/script.php?script_id=1723'
  md5 '2ace56c96fb47cd6f34e47b2d6707729'

  def install
    bin.install 'download_script.php?src_id=13024' => 'vimpager'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end

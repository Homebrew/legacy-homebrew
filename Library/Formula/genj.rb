require 'formula'

class Genj < Formula
  url 'http://downloads.sourceforge.net/project/genj/releases/3.0/genj_mac-3.0.tar.gz'
  homepage 'http://genj.sourceforge.net/'
  md5 'cc1941a743fbd8f4bad4435b686e96f3'
  version '3.0'

  def install
    prefix.install '../GenealogyJ.app'
  end

  def caveats; <<-EOS.undent
    GenealogyJ.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        ln -s #{prefix}/GenealogyJ.app /Applications
    EOS
  end
end

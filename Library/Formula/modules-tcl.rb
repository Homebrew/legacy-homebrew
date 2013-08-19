require 'formula'

class ModulesTcl < Formula
  homepage 'http://modules.sourceforge.net/'
  head 'git://git.code.sf.net/p/modules/modules-tcl'

  def install
    man.install Dir['man/*']
    prefix.install Dir['*']
    cd "#{prefix}" do
      system "make"
    end
  end

  test do
    system "bash", "-i", "-c", "mkdir -p ~/.modules && source /usr/local/opt/modules-tcl/init/bash && module avail"
  end
end

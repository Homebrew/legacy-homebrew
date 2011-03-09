require 'formula'

class Scalate <Formula
  url 'http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/scalate/scalate-distro/1.4.1/scalate-distro-1.4.1-unix-bin.tar.gz'
  version '1.4.1'
  homepage 'http://scalate.fusesource.org/'
  md5 'ed58ac43592bdbb15148a5453b254cee'

  def startup_script
    <<-EOS.undent
    #!/bin/bash
    # This startup script for Scalate calls the real startup script installed
    # to Homebrew's cellar. This avoids issues with local vs. absolute symlinks.

    #{libexec}/bin/scalate $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install %w{ LICENSE.txt ReadMe.html }
    libexec.install Dir['*']

    (bin+'scalate').write startup_script
  end

  def caveats
    <<-EOS.undent
    Software was installed to:
      #{libexec}
    EOS
  end
end

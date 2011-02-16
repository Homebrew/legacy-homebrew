require 'formula'

class Scalate <Formula
  url 'http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/scalate/scalate-distro/1.4.0/scalate-distro-1.4.0-unix-bin.tar.gz'
  version '1.4.0'
  homepage 'http://scalate.fusesource.org/'
  md5 'e2c7f309a2774a13262102ce70f78a21'

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

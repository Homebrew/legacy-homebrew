require 'formula'

class Savana < Formula
  homepage 'http://savana.codehaus.org'
  url 'http://repository.codehaus.org/org/codehaus/savana/1.2/savana-1.2-install.tar.gz'
  md5 'cb0d5907540799d7d48fc23ca80f6b0f'

  def install
    # Remove Windows files
    rm_rf Dir['bin/*.{bat,cmd}']

    prefix.install %w{ COPYING COPYING.LESSER licenses svn-hooks }

    # lib/* and logging.properties are loaded relative to bin
    libexec.install %w[bin lib logging.properties]
    (bin+'sav').write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/sav" "$@"
    EOS

    (prefix+'etc/bash_completion.d').install 'etc/bash_completion' => 'savana-completion.bash'
  end
end

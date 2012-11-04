require 'formula'

class Savana < Formula
  homepage 'http://savana.codehaus.org'
  url 'http://repository.codehaus.org/org/codehaus/savana/1.2/savana-1.2-install.tar.gz'
  sha1 '436523a5fab41f3096748de047ed4ea6d3efa3ef'

  def install
    # Remove Windows files
    rm_rf Dir['bin/*.{bat,cmd}']

    prefix.install %w{ COPYING COPYING.LESSER licenses svn-hooks }

    # lib/* and logging.properties are loaded relative to bin
    libexec.install %w[bin lib logging.properties]
    bin.write_exec_script libexec/'bin/sav'

    (prefix+'etc/bash_completion.d').install 'etc/bash_completion' => 'savana-completion.bash'
  end
end

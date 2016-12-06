require 'formula'

class Savana < Formula
  url 'http://repository.codehaus.org/org/codehaus/savana/1.2/savana-1.2-install.tar.gz'
  md5 'cb0d5907540799d7d48fc23ca80f6b0f'
  version '1.2'
  homepage 'http://savana.codehaus.org'

  skip_clean :all

  # Create a wrapper script in bin that executes the script with the same name in libexec/bin.
  def create_wrapper_script name
    (bin + name).write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
    (bin + name).chmod 0755
  end

  def install
    # Remove Windows files
    rm_rf Dir['bin/*.{bat,cmd}']

    prefix.install %w{ COPYING COPYING.LESSER licenses svn-hooks }
    
    # lib/* and logging.properties are loaded relative to bin
    libexec.install %w[bin lib logging.properties]
    create_wrapper_script 'sav'
    
    # Install the Savana bash completion file, renaming it to be specific to savana.
    (prefix + 'etc/bash_completion.d').install('etc/bash_completion' => 'savana-completion.bash')
  end
  
  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d
    EOS
  end

  def test
    system 'sav help'
  end
end

require 'formula'

class Cdargs <Formula
  url 'http://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz'
  homepage 'http://www.skamphausen.de/cgi-bin/ska/CDargs'
  md5 '50be618d67f0b9f2439526193c69c567'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install-strip"

    rm Dir.glob('contrib/Makefile*')
    prefix.install 'contrib'

    bash_completion_dir = etc+'bash_completion.d'
    bash_completion_dir.mkpath
    ln_sf prefix+'contrib/cdargs-bash.sh', bash_completion_dir+'cdargs-bash.sh'
  end

  def caveats; <<-EOS
Support files for bash, tcsh and emacs are located in #{prefix}/contrib.
The file for bash is also symlinked to #{etc}/bash_completion.d/cdargs-bash.sh. Source it from
your .bash_profile or .bashrc to get nice aliases and bash completion.

Consult the cdargs man page for more details and instructions.
    EOS
  end
end

require 'formula'

class BashCompletion <Formula
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.2.tar.bz2'
  homepage 'http://bash-completion.alioth.debian.org/'
  md5 '88c022a98a02a02293716f840eadd884'
  head 'git://git.debian.org/git/bash-completion/bash-completion.git'

  def install
    inreplace "bash_completion", '/etc/bash_completion', "#{etc}/bash_completion"
    inreplace "bash_completion", 'readlink -f', "readlink"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    puts <<-EOS
==============================================================
Add the following lines to your ~/.bash_profile file:
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
==============================================================
    EOS
  end
end

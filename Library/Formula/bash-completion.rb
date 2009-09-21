require 'brewkit'

class BashCompletion <Formula
  @url='http://bash-completion.alioth.debian.org/files/bash-completion-1.0.tar.gz'
  @homepage='http://bash-completion.alioth.debian.org/'
  @md5='cd1c5648272917fbe0eef4ba30bb93f4'
  @head='git://git.debian.org/git/bash-completion/bash-completion.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    inreplace etc+'bash_completion', 'etc/bash_completion', "#{etc}/bash_completion"
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

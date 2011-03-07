require 'formula'

class TodoTxt <Formula
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.7.tar.gz'
  homepage 'http://todotxt.com/'
  md5 'b4ef313bbb8f185fe4a21ce07ad6933d'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
  end

  def caveats; <<-EOS.undent
    To configure, copy the default config to your home and edit it:
      cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end
end

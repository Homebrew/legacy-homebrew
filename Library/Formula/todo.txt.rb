require 'formula'

class TodoTxt <Formula
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.7.tar.gz'
  homepage 'http://todotxt.com/'
  md5 'b4ef313bbb8f185fe4a21ce07ad6933d'

  def install
    # move the file in #{prefix}
    bin.install 'todo.sh'
    prefix.install 'todo.cfg'
  end

  def caveats
    s = <<-EOS
    You can found the default config file in #{prefix}/todo.cfg.
    Put this file as ~/.todo.cfg an change the default value.
    EOS
  end
end

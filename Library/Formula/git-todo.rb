require 'formula'

class GitTodo < Formula
  homepage 'http://github.com/johnliu/git-todo'
  url 'http://github.com/johnliu/git-todo/archive/0.1.tar.gz'
  sha1 'fc76eb4df506cf1b8251130dfdd5858b04914d07'

  depends_on 'ack' => :recommended

  def install
    bin.install 'git-todo'
    bin.install 'git-todos'
  end

  def test
    system "#{bin}/git-todo"
    system "#{bin}/git-todos"
    system "git todo"
    system "git todos"
  end
end

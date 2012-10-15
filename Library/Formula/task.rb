require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.1.2.tar.gz'
  sha1 '4cd5a5cb562fa407f097e2cd7e7293183773cf5b'

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    (prefix/'etc/bash_completion.d').install 'scripts/bash/task.sh'
    (share/'zsh/site-functions').install 'scripts/zsh/_task'
  end
end

require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.2.0.tar.gz'
  sha1 '70656deb48a460f95370c885e388b475475f64eb'

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    (prefix/'etc/bash_completion.d').install 'scripts/bash/task.sh'
    (share/'zsh/site-functions').install 'scripts/zsh/_task'
  end
end

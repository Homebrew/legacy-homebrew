require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.3.0.tar.gz'
  sha1 'b5390a1c1232bcb727f5a595ac1141184810d09d'
  head 'git://tasktools.org/task.git', :branch => '2.4.0', :shallow => false

  depends_on "cmake" => :build
  depends_on "gnutls" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    bash_completion.install 'scripts/bash/task.sh'
    zsh_completion.install 'scripts/zsh/_task'
  end

  test do
    system "#{bin}/task", "--version"
  end
end

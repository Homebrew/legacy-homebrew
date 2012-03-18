require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.0.0.tar.gz'
  md5 'b850b49f8b69bb4049c07d0914a0f7af'

  skip_clean :all
  depends_on "cmake" => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install"
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

require 'formula'

class Task <Formula
  url 'http://www.taskwarrior.org/download/task-1.9.2.tar.gz'
  homepage 'http://www.taskwarrior.org/'
  md5 'be98cc74fe03b8336250e0b7ed3cd8c7'

  skip_clean :all

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install the bash completion file
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

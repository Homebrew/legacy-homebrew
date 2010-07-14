require 'formula'

class Task <Formula
  url 'http://www.taskwarrior.org/download/task-1.9.1.tar.gz'
  homepage 'http://www.taskwarrior.org/'
  md5 'f486d06a9440a7034516de2a31659d3a'

  def skip_clean? path
    true
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install the bash completion file
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

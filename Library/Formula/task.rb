require 'formula'

class Task <Formula
  url 'http://www.taskwarrior.org/download/task-1.9.4.tar.gz'
  homepage 'http://www.taskwarrior.org/'
  md5 '0c5d9dedb1ead69590af895d16708070'

  skip_clean :all

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install the bash completion file
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

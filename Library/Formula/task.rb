require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-1.9.4.tar.gz'
  md5 '0c5d9dedb1ead69590af895d16708070'

  skip_clean :all

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

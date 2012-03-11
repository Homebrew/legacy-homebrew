require 'formula'

class Task < Formula
  url 'http://www.taskwarrior.org/download/task-1.9.4.tar.gz'
  homepage 'http://www.taskwarrior.org/'
  md5 '0c5d9dedb1ead69590af895d16708070'

  skip_clean :all

  devel do
    url 'http://www.taskwarrior.org/download/task-2.0.0.RC1.tar.gz'
    md5 '42333fa5a0ab3a6b058146182cbb7b1a'
    version '2.0.0.rc1'
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install the bash completion file
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
  end
end

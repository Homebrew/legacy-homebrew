require 'formula'

class Task <Formula
  @url='http://www.taskwarrior.org/download/task-1.9.1.tar.gz'
  @homepage='http://www.taskwarrior.org/'
  @md5='f486d06a9440a7034516de2a31659d3a'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking"

    system "make install"
  end
  
  def skip_clean? path
    true
  end
end

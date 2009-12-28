require 'formula'

class Task <Formula
  @url='http://www.taskwarrior.org/download/task-1.8.5.tar.gz'
  @homepage='http://www.taskwarrior.org/'
  @md5='b7e5ab3abf624027068d9a01bf684035'

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

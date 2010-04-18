require 'formula'

class Task <Formula
  @url='http://www.taskwarrior.org/download/task-1.9.0.tar.gz'
  @homepage='http://www.taskwarrior.org/'
  @md5='0e9f5b6ffdf15509eb5657ae3cc6fe2ef029f8e1'

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

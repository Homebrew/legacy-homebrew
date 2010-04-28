require 'formula'

class Task <Formula
  @url='http://www.taskwarrior.org/download/task-1.9.0.tar.gz'
  @homepage='http://www.taskwarrior.org/'
  @md5='b9c12f60ff509c1ce5c6292041789baa'

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

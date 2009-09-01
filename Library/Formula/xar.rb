require 'brewkit'

class Xar <Formula
  @url='http://xar.googlecode.com/files/xar-1.5.2.tar.gz'
  @homepage='http://code.google.com/p/xar/'
  @md5='8eabb055d3387b8edc30ecfb08d2e80d'

  def patches
    {
      :p1 => ["http://gist.github.com/raw/178912/fe729be5b2572fd8f09eb6b60c9203a35ef1e8c3/gistfile1.diff"]
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

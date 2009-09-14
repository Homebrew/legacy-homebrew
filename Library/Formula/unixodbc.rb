require 'brewkit'

class Unixodbc <Formula
  @url='http://www.unixodbc.org/unixODBC-2.2.14.tar.gz'
  @homepage='http://www.unixodbc.org/'
  @md5='f47c2efb28618ecf5f33319140a7acd0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-gui=no"
    system "make install"
  end
end

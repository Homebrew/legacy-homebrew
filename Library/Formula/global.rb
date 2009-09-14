require 'brewkit'

class Global <Formula
  @url='http://ftp.gnu.org/gnu/global/global-5.6.tar.gz'
  @homepage='http://www.gnu.org/software/global/'
  @md5='cc1f79cb4f62ab4b4c8b5e8a68c51f5e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    
    # we copy these in already
    (share+'gtags').rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
  end
end

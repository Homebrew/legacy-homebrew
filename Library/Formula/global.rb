require 'formula'

class Global <Formula
  @url='http://tamacom.com/global/global-5.8.tar.gz'
  @homepage='http://www.gnu.org/software/global/'
  @md5='7ba2efb55269615b2722cca36aced2cb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    
    # we copy these in already
    Dir.chdir(share+'gtags') do
      FileUtils.rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

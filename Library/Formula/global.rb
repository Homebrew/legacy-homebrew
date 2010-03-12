require 'formula'

class Global <Formula
  url 'http://tamacom.com/global/global-5.8.tar.gz'
  homepage 'http://www.gnu.org/software/global/'
  md5 'f6015f420614dd02082abecd49a4d666'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    
    # we copy these in already
    Dir.chdir(share+'gtags') do
      FileUtils.rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

require 'formula'

class Global <Formula
  url 'http://tamacom.com/global/global-5.8.1.tar.gz'
  homepage 'http://www.gnu.org/software/global/'
  md5 '9c357098e42c9ba32776ccd6b549d85d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # we copy these in already
    Dir.chdir(share+'gtags') do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

require 'formula'

class Global < Formula
  url 'http://ftpmirror.gnu.org/global/global-6.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.0.tar.gz'
  homepage 'http://www.gnu.org/software/global/'
  md5 '5a6439f1fee02d8df3b1ed83049c294e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"

    # we copy these in already
    Dir.chdir(share+'gtags') do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

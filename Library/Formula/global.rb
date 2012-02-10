require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.tar.gz'
  md5 '30f5c6c0f737a3475ec8786ae6e34648'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"

    # we copy these in already
    Dir.chdir(share+'gtags') do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

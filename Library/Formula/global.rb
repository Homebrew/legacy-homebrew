require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.4.tar.gz'
  sha1 'fff915079e7099de0174c47a1a8f6a5b870517d5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"

    # we copy these in already
    cd share+'gtags' do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

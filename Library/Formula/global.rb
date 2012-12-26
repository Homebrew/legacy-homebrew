require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.7.tar.gz'
  sha1 '332606e3e864e65277a6d8d84ab87c8e198b2bd0'

  option 'with-exuberant-ctags', 'Enable Exuberant Ctags as a plug-in parser'

  if build.include? 'with-exuberant-ctags'
    depends_on 'ctags'
    skip_clean 'lib/gtags/exuberant-ctags.la'
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.include? 'with-exuberant-ctags'
      args << "--with-exuberant-ctags=#{HOMEBREW_PREFIX}/bin/ctags"
    end

    system "./configure", *args
    system "make install"

    # we copy these in already
    cd share/'gtags' do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
end

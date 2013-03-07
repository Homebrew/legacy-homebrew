require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.8.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.8.tar.gz'
  sha1 '2adabb332ecf31f0f7c951c3a6d260503a37c9ec'

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

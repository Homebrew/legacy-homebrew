require 'formula'

class Pngcrush <Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/00-1.7.13/pngcrush-1.7.13.tar.bz2'
  md5 'c0816dfc9318d7325008608d321a9228'

  def install
    # use our CFLAGS, LDFLAGS, CC, and LD
    inreplace 'Makefile' do |s|
      s.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
    end

    system "make"
    bin.install 'pngcrush'
  end
end

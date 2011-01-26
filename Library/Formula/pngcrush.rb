require 'formula'

class Pngcrush <Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/00-1.7.14/pngcrush-1.7.14.tar.bz2'
  md5 '56481356267dfdc1d1b30e2dd812f4b0'

  def install
    # use our CFLAGS, LDFLAGS, CC, and LD
    inreplace 'Makefile' do |s|
      s.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
    end

    system "make"
    bin.install 'pngcrush'
  end
end

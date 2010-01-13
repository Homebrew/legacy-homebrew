require 'formula'

class Pngcrush <Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url "http://downloads.sourceforge.net/sourceforge/pmt/pngcrush-1.7.7.tar.bz2"
  md5 '0ac097be4c7eb28504f8a583ee92b103'

  def install
    # use our CFLAGS, LDFLAGS, CC, and LD
    inreplace 'Makefile' do |contents|
      contents.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
    end

    system "make"
    bin.install 'pngcrush'
  end
end

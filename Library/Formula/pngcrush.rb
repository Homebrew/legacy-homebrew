require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://sourceforge.net/projects/pmt/files/pngcrush/1.7.24/pngcrush-1.7.24.tar.bz2'
  md5 '9F29BD4BC05AE1415E5AD10241798794'

  def install
    # use our CFLAGS, LDFLAGS, CC, and LD
    inreplace 'Makefile' do |s|
      s.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
    end

    system "make"
    bin.install 'pngcrush'
  end
end

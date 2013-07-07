require 'formula'

class Dcled < Formula
  homepage 'http://www.jeffrika.com/~malakai/dcled/index.html'
  url 'http://www.jeffrika.com/~malakai/dcled/dcled-2.0.tgz'
  sha1 'db01658b44829a5f6d1eae7264648275bda406ed'

  depends_on 'libhid'

  def install
    inreplace 'makefile' do |s|
      s.change_make_var! 'INSTALLDIR', bin
      s.change_make_var! 'FONTDIR', share+name
      s.change_make_var! 'CC', ENV.cc
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -I#{HOMEBREW_PREFIX}/include"
      s.change_make_var! 'LDFLAGS', ENV.ldflags + ' -lm -lhid' unless ENV.ldflags.nil?
    end

    system "make"
    system "make install"
  end
end

require 'formula'

class Dcled <Formula
  url 'http://www.jeffrika.com/~malakai/dcled/dcled-1.8.tgz'
  homepage 'http://www.jeffrika.com/~malakai/dcled/index.html'
  md5 '1f0c32964ff521c2f39156cca5ef7a29'

  depends_on 'libhid'

  def install
    inreplace 'makefile' do |s|
      s.change_make_var! 'INSTALLDIR', prefix + 'bin'
      s.change_make_var! 'CC', ENV['CC']
      s.change_make_var! 'CFLAGS', ENV['CFLAGS'] + " -I#{HOMEBREW_PREFIX}/include"
      s.change_make_var! 'LDFLAGS', ENV['LDFLAGS'] + ' -lm -lhid'
    end

    system "make && make install"
  end
end

require 'formula'

class Optipng <Formula
  url 'http://downloads.sourceforge.net/optipng/optipng-0.6.4.tar.gz'
  homepage 'http://optipng.sourceforge.net/'
  md5 'd6c10dd8d8f1d5b579221bc9cfbfbcb6'

  def install
    inreplace 'src/scripts/gcc.mak.in' do |s|
      s.gsub! '/usr/local', prefix
      s.change_make_var! 'mandir', man
    end
    system "./configure", "-with-system-zlib"
    system "make install"
  end
end

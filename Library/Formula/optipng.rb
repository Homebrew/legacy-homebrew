require 'formula'

class Optipng <Formula
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.6.5/optipng-0.6.5.tar.gz'
  homepage 'http://optipng.sourceforge.net/'
  md5 '9df5fa7bb45ae096ed6c6e0d8dc43dc7'

  def install
    inreplace 'src/scripts/gcc.mak.in' do |s|
      s.gsub! '/usr/local', prefix
      s.change_make_var! 'mandir', man
    end
    system "./configure", "-with-system-zlib"
    system "make install"
  end
end

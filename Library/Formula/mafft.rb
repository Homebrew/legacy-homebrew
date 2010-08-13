require 'formula'

class Mafft <Formula
  url 'http://align.bmr.kyushu-u.ac.jp/mafft/software/mafft-6.717-with-extensions-src.tgz'
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  md5 '2fc3acfce3a48f9804e8ca5e22bb984d'
  version '6.717'

  def install
    inreplace ["core/Makefile", "extensions/Makefile"] do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MANDIR", man1
    end

    system "cd core/; make install"
    system "cd extensions; make install"
  end
end

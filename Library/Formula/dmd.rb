require 'formula'

class Dmd < Formula
  homepage 'http://www.digitalmars.com/d/'
  url 'http://cloud.github.com/downloads/D-Programming-Language/dmd/dmd.2.060.zip'
  md5 '6cf237d16625bf37a757a413963fa999'

  def doc
    #use d and not dmd, rationale: meh
    prefix+'share/doc/d'
  end

  def install
    # clean it up a little first
    rm Dir['src/*.mak']
    mv 'license.txt', 'COPYING'
    mv 'README.TXT', 'README'

    prefix.install 'osx/bin', 'osx/lib', 'src'
    man.install 'man/man1'

    (prefix+'src/dmd').rmtree # we don't need the dmd sources thanks
    man5.install man1+'dmd.conf.5' # oops
    (share+'d/examples').install Dir['samples/d/*.d']

    # Rewrite the DFLAGS to point to the prefix.
    # @adamv: this should not go into bin!
    # But I'm too lazy to figure out how to fix right now.
    rm bin+'dmd.conf'
    (bin+'dmd.conf').write <<-EOS.undent
      [Environment]
      DFLAGS=-I#{prefix}/src/phobos -I#{prefix}/src/druntime/import
    EOS
  end
end

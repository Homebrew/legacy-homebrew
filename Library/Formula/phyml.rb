require 'formula'

class Phyml < Formula
  homepage 'http://www.atgc-montpellier.fr/phyml/'
  url 'http://phyml.googlecode.com/files/phyml-20110919.tar.gz'
  sha1 '6f6281af465d6daab0d7f774c1d0f62856b1af80'

  def install
    # separate steps required
    system "./configure", "--prefix=#{prefix}"
    system "make"

    system "./configure", "--prefix=#{prefix}", "--enable-phytime"
    system "make"

    bin.install %w(src/phyml src/phytime)
    doc.install Dir['doc/phyml-manual.pdf']
    rm_rf Dir['examples/.svn']
    chmod 0644, Dir['examples/*']
    share.install Dir['examples/*']
  end

  def caveats; <<-EOS.undent
    Examples have been installed here:
      #{share}

    See options for phyml by running:
      phmyl --help

    PhyML must be run with the "-i" option to specify an input or it will
    segfault. Example:
      phyml -i #{share}/nucleic
    EOS
  end
end

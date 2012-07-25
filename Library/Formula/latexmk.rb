require 'formula'

class Latexmk < Formula
  homepage 'http://www.phys.psu.edu/~collins/software/latexmk-jcc/'
  url 'http://www.phys.psu.edu/~collins/software/latexmk-jcc/latexmk-431.zip'
  sha1 '169aa8288e48de2affef5f5dd047d6fe39ae69e9'
  version '4.31'

  def install
    # this package doesn't have a makefile, so we just copy everything ourselves

    mv 'latexmk.pl', 'latexmk'
    bin.mkpath
    bin.install 'latexmk'

    doc.mkpath
    doc.install ['latexmk.pdf', 'latexmk.ps', 'latexmk.txt']

    man1.mkpath
    man1.install 'latexmk.1'

    share.mkpath
    share.install ['example_rcfiles', 'extra-scripts']

    # remove Windows batch files
    Pathname("#{share}/extra-scripts").each_entry {|f|
      if (f.basename.to_s =~ /\.bat$/)
        Pathname("#{share}/extra-scripts/#{f}").delete
      end
    }
  end

  def caveats; <<-EOS.undent
    Example initialization files and auxiliary scripts have been written to
      #{share}/example_rcfiles
      #{share}/extra-scripts
    respectively. See the README files in those directories for more information.
    EOS
  end

  def test
    `#{bin}/latexmk -v` =~ "Latexmk, John Collins"
  end
end

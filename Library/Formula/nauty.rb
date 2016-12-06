require 'formula'

class Nauty < Formula
  url 'http://cs.anu.edu.au/~bdm/nauty/nauty24r2.tar.gz'
  homepage 'http://cs.anu.edu.au/~bdm/nauty/'
  version '24r2'
  md5 '53f83420491a32e3fe9b03a44c559a89'

  def options
    [['--run-tests', "Runs the included test programs"]]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make all"

    if ARGV.include? '--run-tests'
      system "make checks"
    end

    bin.install %w{ NRswitchg addedgeg amtog biplabg catg complg copyg countg
      deledgeg directg dreadnaut dretog genbg geng genrang gentourng labelg
      listg multig newedgeg pickg planarg shortg showg }

    prefix.install 'nug.pdf'
  end

  def caveats
    return <<-EOS.undent
      The nauty User Guide was saved locally to:
          #{prefix}/nug.pdf

      More information on nauty can be found on nauty's homepage:
          http://cs.anu.edu.au/~bdm/nauty/
    EOS
  end
end

require 'formula'

class Nauty < Formula
  homepage 'http://cs.anu.edu.au/~bdm/nauty/'
  url 'http://cs.anu.edu.au/~bdm/nauty/nauty24r2.tar.gz'
  version '24r2'
  sha1 '3f012beb399a9340f77d0104bf1c9bf1100e8286'

  option 'run-tests', "Runs the included test programs"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make all"
    system "make checks" if build.include? 'run-tests'

    bin.install %w{ NRswitchg addedgeg amtog biplabg catg complg copyg countg
      deledgeg directg dreadnaut dretog genbg geng genrang gentourng labelg
      listg multig newedgeg pickg planarg shortg showg }

    prefix.install 'nug.pdf'
  end

  def caveats; <<-EOS.undent
    User guide was saved locally to:
      #{prefix}/nug.pdf
    EOS
  end
end

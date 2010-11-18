require 'formula'

class Ampl <Formula
  url 'http://netlib.sandia.gov/ampl/student/macosx/x86_32/ampl.gz', :using => :nounzip
  homepage 'http://www.ampl.com/'
  version '1.6'
  md5 'f2540bc15bcfd4a59634315c7b3b3fef'

  def caveats; <<-EOS.undent
    This installs the AMPL Student Edition software without any solvers.
    Licensing and registration are the responsibility of the end-user :-)

    To download solvers, visit the AMPL website at
        http://www.ampl.com/DOWNLOADS/details.html#Solvers .

    To install a solver SOLVER after downloading and decompressing it,
        mv path/to/SOLVER `brew --cellar`/ampl/1.6/bin
  EOS
  end

  def install
    system "gunzip ampl.gz"
    system "chmod +x ampl"
    bin.install Dir['*']
  end

end

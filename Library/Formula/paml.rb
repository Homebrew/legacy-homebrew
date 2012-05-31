require 'formula'

class Paml < Formula
  homepage 'http://abacus.gene.ucl.ac.uk/software/paml.html'
  url 'http://abacus.gene.ucl.ac.uk/software/paml4.5.tgz'
  md5 'c87ddcf7e993496be30760ecd542113d'

  def install
    cd 'src' do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg codeml pamp evolver yn00 chi2]
    end

    (share+'paml').install 'dat'
    (share+'paml').install Dir['*.ctl']
    doc.install Dir['doc/*']
  end
end

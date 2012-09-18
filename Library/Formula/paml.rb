require 'formula'

class Paml < Formula
  homepage 'http://abacus.gene.ucl.ac.uk/software/paml.html'
  url 'http://abacus.gene.ucl.ac.uk/software/paml4.6.tgz'
  sha1 '2d12d50695a0d6d324781e75594783e250fbb795'

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

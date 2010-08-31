require 'formula'

# Phylogenetic Analysis by Maximum Likelihood
class Paml <Formula
  url 'http://abacus.gene.ucl.ac.uk/software/paml4.4c.tar.gz'
  homepage 'http://abacus.gene.ucl.ac.uk/software/paml.html'
  md5 '0ab0b722bc28c15b22554ec68576b09f'
  version '4.4c'

  def install
    Dir.chdir 'src' do
      inreplace "Makefile" do |s|
        s.change_make_var! 'CFLAGS', ENV.cflags
      end
      system "make"
      bin.install %w[baseml basemlg codeml pamp evolver yn00 chi2]
    end

    (share+'paml').install 'dat'
    (share+'paml').install Dir['*.ctl']
    doc.install Dir['doc/*']
  end
end

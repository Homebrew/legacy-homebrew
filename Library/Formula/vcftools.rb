require 'formula'

class Vcftools < Formula
  url 'http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.8.tar.gz'
  homepage 'http://vcftools.sourceforge.net/index.html'
  md5 '9895d3f30f2dac1eb01dd774557384de'

  def install
    system "make install PREFIX=#{prefix} CPP=#{ENV.cxx}"
  end

  def test
    system "vcftools"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end
end

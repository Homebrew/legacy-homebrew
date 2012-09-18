require 'formula'

class Vcftools < Formula
  homepage 'http://vcftools.sourceforge.net/index.html'
  url 'http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.9.tar.gz'
  sha1 '86fc8bea605543f8c286b164bc23ee9b2a76215e'

  def install
    system "make", "install", "PREFIX=#{prefix}", "CPP=#{ENV.cxx}"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  def test
    system "#{bin}/vcftools"
  end
end

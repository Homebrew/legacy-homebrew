require 'formula'

class Xpdf < Formula
  url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.03.tar.gz', :using  => :nounzip
  sha1 '499423e8a795e0efd76ca798239eb4d0d52fe248'
end

class Swftools < Formula
  homepage 'http://www.swftools.org'
  url 'http://www.swftools.org/swftools-0.9.2.tar.gz'
  sha1 'd7cf8874c4187d2edd3e40d20ba325ca17b91973'

  depends_on 'jpeg'
  depends_on 'lame'
  depends_on 'giflib'
  depends_on 'fftw'

  def patches
    # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
    # rather than fftwf_malloc().  Reported upstream to their mailing list:
    # http://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
    # Patch is merged upstream.  Remove at swftools-0.9.3.
    DATA
  end

  def install
    ENV.x11 # Add to PATH for freetype-config on Snow Leopard
    Xpdf.new.brew { (buildpath+'lib/pdf').install Dir['*'] }
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
--- a/configure	2012-04-08 10:25:35.000000000 -0700
+++ b/configure	2012-04-09 17:42:10.000000000 -0700
@@ -6243,7 +6243,7 @@
 
     int main()
     {
-	char*data = fftw_malloc(sizeof(fftwf_complex)*600*800);
+	char*data = fftwf_malloc(sizeof(fftwf_complex)*600*800);
     	fftwf_plan plan = fftwf_plan_dft_2d(600, 800, (fftwf_complex*)data, (fftwf_complex*)data, FFTW_FORWARD, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_r2c_2d(600, 800, (float*)data, (fftwf_complex*)data, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_c2r_2d(600, 800, (fftwf_complex*)data, (float*)data, FFTW_ESTIMATE);

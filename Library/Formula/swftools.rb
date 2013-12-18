require 'formula'

class Swftools < Formula
  homepage 'http://www.swftools.org'
  url 'http://www.swftools.org/swftools-0.9.2.tar.gz'
  sha1 'd7cf8874c4187d2edd3e40d20ba325ca17b91973'

  option 'with-xpdf', 'Build with PDF support'

  depends_on :x11 if build.with? "xpdf"
  depends_on 'jpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'giflib' => :optional
  depends_on 'fftw' => :optional

  resource 'xpdf' do
    url 'ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.03.tar.gz', :using  => :nounzip
    sha1 '499423e8a795e0efd76ca798239eb4d0d52fe248'
  end

  def patches
    # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
    # rather than fftwf_malloc().  Reported upstream to their mailing list:
    # http://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
    # Patch is merged upstream.  Remove at swftools-0.9.3.
    DATA
  end

  def install
    (buildpath+'lib/pdf').install resource('xpdf') if build.with? "xpdf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/png2swf", "swftools_test.swf", "/usr/share/doc/cups/images/cups.png"
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

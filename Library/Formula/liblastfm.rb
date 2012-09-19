require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/mxcl/liblastfm/'
  url 'https://github.com/mxcl/liblastfm/tarball/0.3.3'
  sha1 'f2e9705c9c2cbeaa14f46da9bd35ab36fe710392'

  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'libsamplerate'

  def patches
	  DATA
  end

  def install
    system "./configure", "--release", "--prefix", prefix
    system "make"
    system "make install"
  end
end

__END__
diff --git a/src/fingerprint/fplib/FloatingAverage.h b/src/fingerprint/fplib/FloatingAverage.h
index 1be665b..958087e 100644
--- a/src/fingerprint/fplib/FloatingAverage.h
+++ b/src/fingerprint/fplib/FloatingAverage.h
@@ -76,7 +76,7 @@ public:
    {
       T real_sum = 0;
       const T* pCircularBuffer = m_values.get_buffer();
-      for ( int i = 0; i < size; ++i )
+      for ( int i = 0; i < size(); ++i )
          real_sum += pCircularBuffer[i];
       return abs(real_sum - m_sum) / this->size();
    }


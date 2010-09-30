require 'formula'

class Swftools <Formula
  url 'http://www.swftools.org/swftools-0.9.1.tar.gz'
  homepage 'http://www.swftools.org'
  md5 '72dc4a7bf5cdf98c28f9cf9b1d8f5d7a'

  depends_on 'jpeg'
  depends_on 'lame' => :optional

  def install
    ENV.x11 # Add to PATH for freetype-config on Snow Leopard
    ENV.minimal_optimization

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    `swfc` segfaults under Snow Leopard.
    Please persue this issue with the softare vendor:
      http://lists.nongnu.org/mailman/listinfo/swftools-common
    EOS
  end
end

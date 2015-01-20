require 'formula'

class Snzip < Formula
  homepage 'https://github.com/kubo/snzip'
  url 'https://bintray.com/artifact/download/kubo/generic/snzip-1.0.2.tar.gz'
  sha1 '6efa5f6e097a9bed10b526cfbf4062e2f547be56'

  depends_on 'snappy'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.out').write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end

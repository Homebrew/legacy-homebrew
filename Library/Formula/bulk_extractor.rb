require 'formula'

class BulkExtractor <Formula
  url 'http://afflib.org/downloads/bulk_extractor-0.4.5.tar.gz'
  homepage 'http://afflib.org/software/bulk_extractor'
  md5 'b220653a731f83dde8328a6964e59f3c'
  
  depends_on 'libewf' => :optional
  depends_on 'afflib' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

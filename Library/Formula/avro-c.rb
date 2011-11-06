require 'formula'

class AvroC < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.5.1/c/avro-c-1.5.1.tar.gz'
  homepage 'http://avro.apache.org/'
  md5 '80228a62dd58ec19eb8d436258b91952'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

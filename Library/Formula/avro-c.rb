require 'formula'

class AvroC < Formula
  url 'http://mirror.atlanticmetro.net/apache/avro/avro-1.4.0/c/avro-c-1.4.0.tar.gz'
  homepage 'http://avro.apache.org/'
  md5 'fdcd3916cbfc459a6938141028cf35e6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

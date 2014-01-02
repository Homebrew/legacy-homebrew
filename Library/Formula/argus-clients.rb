require 'formula'

class ArgusClients < Formula
  homepage 'http://qosient.com/argus/'
  url 'http://qosient.com/argus/src/argus-clients-3.0.6.2.tar.gz'
  sha1 '27a265e7c3cf6f11f992c14698ee50123a01091f'

  depends_on 'readline' => :recommended
  depends_on 'rrdtool' => :recommended

  def install
    ENV.append 'CFLAGS', '-std=gnu89'
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

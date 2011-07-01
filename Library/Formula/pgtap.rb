require 'formula'

class Pgtap < Formula
  url 'http://pgfoundry.org/frs/download.php/2701/pgtap-0.24.tar.bz2'
  homepage 'http://pgtap.org'
  md5 '9d0360c87fca0ddf3ca9da49b9b71947'

  depends_on 'postgresql'

  skip_clean :all

  def install
    system "make install"
    bin.install %w(bbin/pg_prove bbin/pg_tapgen)
  end
end

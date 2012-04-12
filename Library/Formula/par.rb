require 'formula'

class Par < Formula
  url 'http://www.nicemice.net/par/Par152.tar.gz'
  homepage 'http://www.nicemice.net/par/'
  md5 '4ccacd824171ba2c2f14fb8aba78b9bf'

  def patches
    # A patch by Jérôme Pouiller that adds support for multibyte
    # charsets (like UTF-8), plus Debian packaging.
    "http://www.nicemice.net/par/par_1.52-i18n.3.diff.gz"
  end

  def install
    system "make -f protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end
end

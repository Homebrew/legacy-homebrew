require 'formula'

class Par < Formula
  homepage 'http://www.nicemice.net/par/'
  url 'http://www.nicemice.net/par/Par152.tar.gz'
  sha1 '4b83d2ec593bb45ee46d4b7c2bfc590e1f4a41a8'

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

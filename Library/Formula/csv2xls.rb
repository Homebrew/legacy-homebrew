require "formula"

class Csv2xls < Formula
  homepage 'http://ferkulat.github.io/csv2xls/'
  url 'https://github.com/ferkulat/csv2xls/releases/download/0.3.4/csv2xls-0.3.4.tar.bz2'
  sha1 "6140301b3187932c46fc02ea7bf70f2b0be6421b"

  depends_on 'xlslib'
  depends_on 'libcsv'

  def install

    system "./configure", "--disable-debug"
    system "make"
    system "make", "install"
  end
end

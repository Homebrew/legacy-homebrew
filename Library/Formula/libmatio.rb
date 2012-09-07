require 'formula'

class Libmatio < Formula
  homepage 'http://matio.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/matio/matio/1.5.0/matio-1.5.0.tar.bz2'
  sha1 'b2e4f5524a9d7ce1fb268a67bb5b1a7427d047d4'

  depends_on 'hdf5' if ARGV.include? '--with-hdf5'

  def options
    [
      ['--with-hdf5', 'to work with newer MAT files that use the HDF5-format']
    ]
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
    ]

    if ARGV.include? '--with-hdf5'
      args.concat ["--with-hdf5=#{HOMEBREW_PREFIX}"]
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end

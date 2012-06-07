require 'formula'

class Dcmtk < Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz'
  md5 '19409e039e29a330893caea98715390e'

  depends_on :x11
  depends_on 'libtiff'
  depends_on 'doxygen' if ARGV.include? '--with-docs'

  def options
    [['--with-docs', 'Install development libraries/headers and HTML docs']]
  end

  fails_with :clang do
    build 318
  end

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << '-DDCMTK_WITH_DOXYGEN=YES' if ARGV.include? '--with-docs'

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make DOXYGEN' if ARGV.include? '--with-docs'
      system 'make install'
    end
  end
end

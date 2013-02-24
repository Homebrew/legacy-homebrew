require 'formula'

class Dcmtk < Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz'
  sha1 '469e017cffc56f36e834aa19c8612111f964f757'

  option 'with-docs', 'Install development libraries/headers and HTML docs'

  depends_on 'cmake' => :build
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'doxygen' if build.include? 'with-docs'

  fails_with :clang do
    build 421
  end

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << '-DDCMTK_WITH_DOXYGEN=YES' if build.include? 'with-docs'
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make DOXYGEN' if build.include? 'with-docs'
      system 'make install'
    end
  end
end

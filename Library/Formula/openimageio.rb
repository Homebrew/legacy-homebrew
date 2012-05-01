require 'formula'

class J2kp4files < Formula
  url 'http://pkgs.fedoraproject.org/repo/pkgs/openjpeg/j2kp4files_v1_5.zip/27780ed3254e6eb763ebd718a8ccc340/j2kp4files_v1_5.zip'
  md5 '27780ed3254e6eb763ebd718a8ccc340'
end

class Tiffpic < Formula
  url 'ftp://ftp.remotesensing.org/pub/libtiff/pics-3.8.0.tar.gz'
  sha1 'f50e14335fd98f73c6a235d3ff4d83cf4767ab37'
end

class Bmpsuite < Formula
  url 'http://entropymine.com/jason/bmpsuite/bmpsuite.zip'
  sha1 '2e43ec4d8e6f628f71a554c327433914000db7ba'
  version '1.0.0'
end

class Tgautils < Formula
  url 'http://makseq.com/materials/lib/Code/FileFormats/BitMap/TARGA/TGAUTILS.ZIP'
  sha1 '0902c51e7b00ae70a460250f60d6adc41c8095df'
  version '1.0.0'
end

class OpenexrImages < Formula
  url 'http://download.savannah.nongnu.org/releases/openexr/openexr-images-1.5.0.tar.gz'
  sha1 '22bb1a3d37841a88647045353f732ceac652fd3f'
end

class OiioImages < Formula
  url 'https://github.com/OpenImageIO/oiio-images/tarball/9bf43561f5'
  sha1 '8f12a86098120fd10ceb294a0d3aa1c95a0d3f80'
  version '1.0.0'
  def initialize; super "oiioimages"; end
end


class Openimageio < Formula
  homepage 'http://openimageio.org'
  url 'https://github.com/OpenImageIO/oiio/tarball/Release-1.0.3'
  sha1 '69919017a9fbc716d593eb508d04ea46626e96ed'

  head 'https://github.com/OpenImageIO/oiio.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'opencolorio'
  depends_on 'ilmbase'
  depends_on 'openexr'
  depends_on 'boost'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'openjpeg'
  depends_on 'cfitsio'
  depends_on 'hdf5'
  depends_on 'field3d'
  depends_on 'webp'
  depends_on 'glew'
  depends_on 'qt'

  def options
    [['--with-tests',  'Dowload 95MB of test images and verify Oiio (~2 min).']]
  end

  def install
    # Oiio is designed to have its testsuite images extracted one directory
    # above the source.  That's not a safe place for HB.  Do the opposite,
    # and move the entire source down into a subdirectory if --with-tests.
    if ARGV.include? '--with-tests' then
      (buildpath+'localpub').install Dir['*']
      chdir 'localpub'
    end

    ENV.append 'MY_CMAKE_FLAGS', "-Wno-dev"   # stops a warning.
    args = ["USE_TBB=1", "EMBEDPLUGINS=1"]


    python_prefix = `python-config --prefix`.strip
    # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
    if File.exist? "#{python_prefix}/Python"
      # Python was compiled with --framework:
      ENV.append 'MY_CMAKE_FLAGS', "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
      ENV.append 'MY_CMAKE_FLAGS', "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
    else
      python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
      python_lib = "#{python_prefix}/lib/libpython#{python_version}"
      ENV.append 'MY_CMAKE_FLAGS', "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/python#{python_version}'"
      if File.exists? "#{python_lib}.a"
        ENV.append 'MY_CMAKE_FLAGS', "-DPYTHON_LIBRARY='#{python_lib}.a'"
      else
        ENV.append 'MY_CMAKE_FLAGS', "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
      end
    end


    # Download standardized test images if the user throws --with-tests.
    # 90% of the images are in tarballs, so they are cached normally.
    # The webp and fits images are loose.  Curl them each install.
    if ARGV.include? '--with-tests' then
      d = buildpath
      mkdir d+'webp-images' do
        curl "http://www.gstatic.com/webp/gallery/[1-5].webp", "-O"
      end
      mkdir d+'fits-images'
      mkdir d+'fits-images/pg93' do
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst000[1-3].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst000[5-9].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst0013.fits", "-O"
      end
      mkdir d+'fits-images/ftt4b' do
        curl "http://www.cv.nrao.edu/fits/data/tests/ftt4b/file00[1-3].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/ftt4b/file0{09,12}.fits", "-O"
      end
      J2kp4files.new.brew { (d+'j2kp4files_v1_5').install Dir['J2KP4files/*'] }
      Tiffpic.new.brew { (d+'libtiffpic').install Dir['*'] }
      Bmpsuite.new.brew { (d+'bmpsuite').install Dir['*'] }
      Tgautils.new.brew { (d+'TGAUTILS').install Dir['*'] }
      OpenexrImages.new.brew { (d+'openexr-images-1.5.0').install Dir['*'] }
      OiioImages.new.brew { (d+'oiio-images').install Dir['*'] }
    end


    # make is a shell wrapper for cmake crafted by the devs (who have Lion).
    system "make", *args
    system "make test" if ARGV.include? '--with-tests'
    # There is no working make install in 1.0.2, devel or HEAD.
    Dir.chdir 'dist/macosx' do
      (lib + which_python ).install 'lib/python/site-packages'
      prefix.install %w[ bin include ]
      lib.install    Dir[ 'lib/lib*' ]
      doc.install    'share/doc/openimageio/openimageio.pdf'
      prefix.install Dir['share/doc/openimageio/*']
    end
  end

  def caveats; <<-EOS.undent
    If OpenImageIO is brewed using non-homebrew Python, then you need to amend
    your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

require 'formula'

class Pbrt <Formula
  head 'git://github.com/mmp/pbrt-v2.git'
  homepage 'http://www.pbrt.org/'

  depends_on 'openexr'
  depends_on 'libtiff'
  depends_on 'ilmbase'

  def install
    # Configure the Makefile
    inreplace 'src/Makefile' do |contents|
      openexr = Formula.factory('openexr')
      libtiff = Formula.factory('libtiff')
      ilmbase = Formula.factory('ilmbase')

      # Enable Tiff support
      contents.change_make_var! "HAVE_LIBTIFF", "1"

      # Set LibTiff path
      contents.change_make_var! "TIFF_INCLUDES", "-I#{libtiff.include}"
      contents.change_make_var! "TIFF_LIBDIR", "-L#{libtiff.lib}"

      # Set OpenEXR path
      contents.change_make_var! "EXR_INCLUDES", "-I#{openexr.include}/OpenEXR -I#{ilmbase.include}/OpenEXR"
      contents.change_make_var! "EXR_LIBDIR", "-L#{openexr.lib} -L#{ilmbase.lib}"

      # Change settings if we are using a 32bit system
      if MACOS_VERSION <= 10.5 or Hardware.is_32_bit?
        contents.change_make_var! "MARCH", "-m32 -msse2 -mfpmath=sse"
      end
    end

    # Build and install
    system "make -C src"
    bin.install Dir['src/bin/*']

    # Copy resources
    prefix.install %w(dtrace exporters scenes)
  end
end

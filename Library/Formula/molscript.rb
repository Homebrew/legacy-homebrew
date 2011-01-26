require 'formula'

class Molscript <Formula
  url 'http://www.avatar.se/molscript/molscript-2.1.2.tar.gz'
  homepage 'http://www.avatar.se/molscript'
  md5 'bfd8ff54d22afe200f050829ee41e197'

  def install

    mv 'Makefile.complete', 'Makefile'

    inreplace 'Makefile' do |s|
      # Use frameworks
      s.change_make_var! 'GLUTLINK', '-framework OpenGL -framework GLUT -L/usr/X11/lib -lGL -lXmu -lXext -lX11'
      s.change_make_var! 'OPENGLFLAG','-DOPENGL_SUPPORT -I/usr/X11/include'
      # remove graphical image output, see caveat
      s.remove_make_var! [ 'JPEGDIR', 'JPEGLINK', 'JPEGFLAG', 'JPEGOBJ', 'ZLIBDIR', 'ZLIBLINK',
        'PNGLINK', 'PNGFLAG', 'PNGOBJ', 'GIFDIR', 'GIFLINK', 'GIFFLAG', 'GIFOBJ' ]
      s.change_make_var! 'CC', ENV.cc
      s.change_make_var! 'COPT', ENV.cflags
      s.remove_make_var! 'CCHECK'
    end

    # Fix-up GLUT header
    inreplace 'clib/ogl_bitmap_character.c' do |s|
      s.gsub! '#include <../lib/glut/glutbitmap.h>', '#include <GLUT/glutbitmap.h>'
    end

    system 'make'

    # Install programs
    bin.install [ 'molscript', 'molauto' ]

    # Install extras
    mkdir 'molscript'
    system 'mv', 'examples', 'doc', 'molscript'
    share.install Dir['molscript']

    def caveats; <<-EOS.undent
      Molscript has been compiled with OpenGL but without other graphics support.
      Use the -r switch and Raster3D to create graphical images.  Raster3D offers
      more control and more options.

        e.g., molscript -r < infile | render -jpeg image.jpeg

      Install Raster3d with:

        "brew install raster3d"

      Please read the appropriate molscript license found in:

      #{share}/molscript/doc.
      EOS
    end

  end

end

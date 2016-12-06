require 'formula'

class Raster3d <Formula
  # brew does not automatically decompress this archive so add strategy to stop future breakage
  url 'http://skuld.bmsc.washington.edu/raster3d/Raster3D_2.9-2.tar.gz',
    :using => NoUnzipCurlDownloadStrategy
  homepage 'http://skuld.bmsc.washington.edu/raster3d/'
  md5 '3340d75c51dca3d2188b818057627d05'

  depends_on 'gfortran'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'imagemagick' => :optional
  version '2.9.2'

  def install

    system 'tar', '-xf', 'Raster3D_2.9-2.tar.gz'
    Dir.chdir 'Raster3D_2.9-2'

    system 'make', 'linux-gfortran'

    inreplace 'Makefile.incl' do |s|
      s.change_make_var! 'INCDIRS', '-I/usr/include -I/usr/local/include -I/usr/X11/include'
      s.change_make_var! 'LIBDIRS', '-L/usr/local/lib -L/usr/X11/lib'
    end

    system 'make'

    # Install programs
    bin.install [ 'avs2ps', 'balls', 'rastep', 'render', 'ribbon', 'rings3d', 'rods', 'normal3d', 'label3d', 'stereo3d' ]

    # Install and fixup manpages
    manpages = %w( avs2ps balls rastep render raster3d ribbon r3d_objects r3dtops rods normal3d label3d stereo3d )
    manpages.each {|m| man1.install "doc/#{m}.l" => "#{m}.1"}

    # Install extras
    mkdir 'Raster3D'
    system 'mv', 'examples', 'html', 'materials', 'Raster3D'
    share.install Dir['Raster3D']

  end

end

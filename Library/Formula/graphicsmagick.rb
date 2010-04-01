require 'formula'
require "#{File.dirname __FILE__}/imagemagick.rb"

class Graphicsmagick < Imagemagick
  url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.12/GraphicsMagick-1.3.12.tar.bz2'
  homepage 'http://www.graphicsmagick.org/'
  md5 '55182f371f82d5f9367bce04e59bbf25'

  def deps
    # well this was an unexpected consequence of the DSL syntax, the dependencies
    # aren't inherited
    @deps ||= Formula.factory('imagemagick').deps
  end

  def install
    ENV.libpng
    ENV.gcc_4_2

    fix_configure

    system "./configure", *configure_args
    system "make install"
  end
end

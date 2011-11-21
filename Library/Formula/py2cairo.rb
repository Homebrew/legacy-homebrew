require 'formula'

class Py2cairo < Formula
  url 'http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2'
  homepage 'http://cairographics.org/pycairo/'
  md5 '20337132c4ab06c1146ad384d55372c5'

  depends_on 'pkg-config' => :build
  depends_on 'python'
  depends_on 'cairo'

  def install
    py_prefix = `brew --prefix python`.chomp
    cairo_prefix = `brew --prefix cairo`.chomp

    ohai "#{py_prefix}/bin/python"

    ENV.prepend 'PKG_CONFIG_PATH', cairo_prefix
    ENV['ARCHFLAGS'] = archs_for_command("#{py_prefix}/bin/python").as_arch_flags
    system "./waf configure --prefix=#{prefix}"
    system "./waf build"

    # Grrr. Despite all efforts, this still links against system Python.
    # Fix it with brute force and ignorance:
    system "install_name_tool -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python #{py_prefix   }/lib/libpython2.7.dylib ./build_directory/src/_cairo.so"

    system "./waf install"
  end
end

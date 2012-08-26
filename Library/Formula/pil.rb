require 'formula'

class Pil < Formula
  url 'http://effbot.org/downloads/Imaging-1.1.7.tar.gz'
  homepage 'http://www.pythonware.com/products/pil/'
  md5 'fc14a54e1ce02a0225be8854bfba478e'

  depends_on :x11
  depends_on 'jpeg' => :recommended
  depends_on 'little-cms' => :optional

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    # Can't build universal on 32-bit hardware. See:
    # https://github.com/mxcl/homebrew/issues/5844
    archs.delete :x86_64 if Hardware.is_32_bit?
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    inreplace "setup.py" do |s|
      # Tell setup where Freetype2 is on 10.5/10.6
      s.gsub! 'add_directory(include_dirs, "/sw/include/freetype2")',
<<<<<<< HEAD
              "add_directory(include_dirs, \"#{MacOS::XQuartz.include}\")"

      s.gsub! 'add_directory(include_dirs, "/sw/lib/freetype2/include")',
              "add_directory(library_dirs, \"#{MacOS::XQuartz.lib}\")"
=======
              "add_directory(include_dirs, \"#{MacOS::X11.include}\")"

      s.gsub! 'add_directory(include_dirs, "/sw/lib/freetype2/include")',
              "add_directory(library_dirs, \"#{MacOS::X11.lib}\")"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

      # Tell setup where our stuff is
      s.gsub! 'add_directory(library_dirs, "/sw/lib")',
              "add_directory(library_dirs, \"#{HOMEBREW_PREFIX}/lib\")"

      s.gsub! 'add_directory(include_dirs, "/sw/include")',
              "add_directory(include_dirs, \"#{HOMEBREW_PREFIX}/include\")"
    end

    system "python", "setup.py", "build_ext"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    This formula installs PIL against whatever Python is first in your path.
    This Python needs to have either setuptools or distribute installed or
    the build will fail.
    EOS
  end
end

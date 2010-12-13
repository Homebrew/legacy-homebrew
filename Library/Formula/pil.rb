require 'formula'

class Pil <Formula
  url 'http://effbot.org/downloads/Imaging-1.1.7.tar.gz'
  homepage 'http://www.pythonware.com/products/pil/'
  md5 'fc14a54e1ce02a0225be8854bfba478e'

  depends_on 'jpeg' => :recommended
  depends_on 'little-cms' => :optional

  def install
    # barfs with any of  -march=core2 -mmmx -msse4.1
    ENV.minimal_optimization

    inreplace "setup.py" do |s|
      # Tell setup where Freetype2 is on 10.5/10.6
      s.gsub! 'add_directory(include_dirs, "/sw/include/freetype2")',
              'add_directory(include_dirs, "/usr/X11/include")'

      s.gsub! 'add_directory(include_dirs, "/sw/lib/freetype2/include")',
              'add_directory(library_dirs, "/usr/X11/lib")'

      # Tell setup where our stuff is
      s.gsub! 'add_directory(library_dirs, "/sw/lib")',
              "add_directory(library_dirs, \"#{HOMEBREW_PREFIX}/lib\")"

      s.gsub! 'add_directory(include_dirs, "/sw/include")',
              "add_directory(include_dirs, \"#{HOMEBREW_PREFIX}/include\")"
    end

    system "python", "setup.py", "build_ext"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats
    <<-EOS.undent
      This formula installs PIL against whatever Python is first in your path.
      This Python needs to have either setuptools or distribute installed or the
      build will fail.

      If you are using a Homebrew-built Python, you can do:
        brew install distribute
      to get this support library.

      If you are using a custom Python, run:
        brew info distribute
      to see manual setup instructions.
    EOS
  end
end

require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz'
  sha256 'fd3c64cb66f2c4ea27e934d275904d92cec494a8e8405613780cbc8a71680fdb'

  keg_only :provided_by_osx

  option :universal

  depends_on :python => :recommended

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python"
    system "make"
    ENV.deparallelize
    system "make install"

    python do
      # This python do block sets up the site-packages in the Cellar.
      cd 'python' do
        # We need to insert our include dir first
        inreplace 'setup.py', 'includes_dir = [', "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
        system python, 'setup.py', "install", "--prefix=#{prefix}"
      end
      # This is keg_only but it makes sense to have the python bindings:
      ohai 'Linking python bindings'
      Dir["#{python.site_packages}/*"].each{ |f|
        path = python.global_site_packages/(Pathname.new(f).basename)
        puts path
        rm path if path.exist?
        ln_s f, path
      }
    end

  end

  def caveats
    <<-EOS.undent
      Even if this formula is keg_only, the python bindings have been linked
      into the global site-packages for your convenience.
        #{python.global_site_packages}

      EOS
  end if build.with? 'python'

  def test
    if build.with? 'python'
      system python, '-c', "import libxml2"
    else
      puts "No tests beacuse build --wtihout-python."
      true
    end
  end
end

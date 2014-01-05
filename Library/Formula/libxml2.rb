require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'

  stable do
    url 'ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz'
    mirror 'http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz'
    sha256 'fd3c64cb66f2c4ea27e934d275904d92cec494a8e8405613780cbc8a71680fdb'

    # 2.9.1 cannot build with Python 2.6: https://github.com/Homebrew/homebrew/issues/20249
    if MacOS.version <= :snow_leopard
      depends_on 'python' => :optional
    else
      depends_on :python => :recommended
    end
  end

  head do
    url 'https://git.gnome.org/browse/libxml2', :using => :git

    depends_on :python => :recommended # satisfied by Python 2.6+
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  keg_only :provided_by_osx

  option :universal

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    if build.head?
      inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'
      system './autogen.sh'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python"
    system "make"
    ENV.deparallelize
    system "make install"

    if build.with? 'python'
      cd 'python' do
        # We need to insert our include dir first
        inreplace 'setup.py', 'includes_dir = [', "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
        system "python", 'setup.py', "install", "--prefix=#{prefix}"
      end
    end
  end
end

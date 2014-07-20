require 'formula'

class Libxml2 < Formula
  homepage 'http://xmlsoft.org'

  stable do
    url 'ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz'
    mirror 'http://xmlsoft.org/sources/libxml2-2.9.1.tar.gz'
    sha256 'fd3c64cb66f2c4ea27e934d275904d92cec494a8e8405613780cbc8a71680fdb'
  end

  bottle do
    revision 1
    sha1 "beea5228f6757f6527aa4714f16c76f773a8c8fe" => :mavericks
    sha1 "74b53656cc103b6c2c397ca0a96d9be1f3afa8c0" => :mountain_lion
    sha1 "9590f024de3820d9b45de979ea9171b17058f69d" => :lion
  end

  head do
    url 'https://git.gnome.org/browse/libxml2', :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :python => :optional

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

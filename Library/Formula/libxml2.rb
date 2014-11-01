require "formula"

class Libxml2 < Formula
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
  sha256 "5178c30b151d044aefb1b08bf54c3003a0ac55c59c866763997529d60770d5bc"

  bottle do
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
                          "--without-python",
                          "--without-lzma"
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

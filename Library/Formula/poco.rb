require "formula"
require "fileutils"

class Poco < Formula
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.4.7/poco-1.4.7p1-all.tar.bz2"
  sha1 "29339fe4b9318d7f358f400e0847856a27ea6c4a"

  bottle do
    cellar :any
    sha1 "3deaf590ff6e90c7c9ddd70f38a39ad4e85ebafd" => :yosemite
    sha1 "e42e56f7bf77d64ce7decc089a948a04feeccceb" => :mavericks
    sha1 "270e0119505e7608d86d897cdb65f3452f9850a2" => :mountain_lion
  end

  devel do
    url "http://pocoproject.org/releases/poco-1.5.4/poco-1.5.4-all.tar.bz2"
    sha1 "f44b57539511bb23f6bb5387347ca08bdd9c724d"
  end

  option :cxx11
  option :universal

  depends_on "openssl"

  def install

    ENV.cxx11 if build.cxx11?

    # the poco project handles most of the architecture specific configuration
    if build.universal?
      archs = {
        "i386" => "Darwin32",
        "x86_64" => "Darwin64"
      }
    elsif MacOS.prefer_64_bit?
      archs = {
        "x86_64" => "Darwin64"
      }
    else
      archs = {
        "i386" => "Darwin32"
      }
    end

    arch_dir = ""
    arch_dirs = []

    archs.each do |arch, arch_mac|
      if build.universal?
        # create an architecture specific temporary directory
        arch_dir = File.join(Dir.pwd, "build-#{arch}")
        rm_rf arch_dir
        arch_dirs << arch_dir
        mkdir arch_dir

        # clean the project before compiling
        system "make", "clean"
      end

      # homebrew sets -march=native by default, need to override to compile for i386
      if arch == "i386"
        ENV['HOMEBREW_OPTFLAGS'] = '-m32'
      else
        ENV['HOMEBREW_OPTFLAGS'] = '-m64'
      end

      system "./configure", "--prefix=#{prefix}",
                            "--config=#{arch_mac}",
                            "--omit=Data/MySQL,Data/ODBC",
                            "--no-samples",
                            "--no-tests"

      system "make"

      if build.universal?
        # move the compiled architecture specific library files to a temporary directory
        arch_libs_dir = File.join(Dir.pwd, "lib/Darwin/#{arch}")
        Dir.glob(File.join(arch_libs_dir, '*')).each do |lib_filename|
          if !File.directory?(lib_filename) && !File.symlink?(lib_filename)
            cp(lib_filename, File.join(arch_dir, File.basename(lib_filename)))
          end
        end
      end
    end

    # install everything else
    system "make", "install"

    if build.universal?
      # combine the compiled architecture specific libraries into universal ones
      Dir.glob(File.join(arch_dirs.first, '*')).each do |path|
        lib_filename = File.basename path
        system "lipo", "-create", File.join(arch_dirs.first, lib_filename),
                                  File.join(arch_dirs.last, lib_filename),
                       "-output", File.join(lib, lib_filename)
      end
    end
  end
end


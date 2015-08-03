require "formula"

class Poco < Formula
  desc "POCO C++ Libraries"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.6.0/poco-1.6.0-all.tar.gz"
  sha1 "b45486757bfc132631d31724342a62cf41dc2795"

  bottle do
    cellar :any
    sha1 "32c3d4f754f5fd1b01fa2455a070f5057582a1a4" => :yosemite
    sha1 "1d844a6baf5ffa6c19697623aceb0d0035e4be38" => :mavericks
    sha1 "4f039170113a69a61657d35a2a0206743bd7f416" => :mountain_lion
  end

  option :cxx11
  option :universal

  depends_on "openssl"

  def install
    ENV.permit_arch_flags
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
        arch_dir = "#{Dir.pwd}/build-#{arch}"
        rm_rf arch_dir
        arch_dirs << arch_dir
        mkdir arch_dir

        # clean the project before compiling
        system "make", "clean"
      end

      system "./configure", "--prefix=#{prefix}",
                            "--config=#{arch_mac}",
                            "--omit=Data/MySQL,Data/ODBC",
                            "--no-samples",
                            "--no-tests"

      system "make"

      if build.universal?
        # move the compiled architecture specific library files to a temporary directory
        arch_libs_dir = "#{Dir.pwd}/lib/Darwin/#{arch}"
        Dir.glob("#{arch_libs_dir}/*").each do |lib_filename|
          if !File.directory?(lib_filename) && !File.symlink?(lib_filename)
            cp(lib_filename, "#{arch_dir}/#{File.basename(lib_filename)}")
          end
        end
      end
    end

    # install everything else
    system "make", "install"

    if build.universal?
      # combine the compiled architecture specific libraries into universal ones
      Dir.glob("#{arch_dirs.first}/*").each do |path|
        lib_filename = File.basename path
        system "lipo", "-create", "#{arch_dirs.first}/#{lib_filename}",
                                  "#{arch_dirs.last}/#{lib_filename}",
                       "-output", "#{lib}/#{lib_filename}"
      end
    end
  end
end

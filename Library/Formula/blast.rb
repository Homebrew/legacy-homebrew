require 'formula'

class Blast < Formula
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  url 'ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.27/ncbi-blast-2.2.27+-src.tar.gz'
  version '2.2.27'
  sha1 '51529c9fada67e890b994213d26f4177fa3d23d8'

  fails_with :llvm do
    build 5658
    cause <<-EOS.undent
      Compiler segfaults.
    EOS
  end

  option 'with-dll', "Create dynamic binaries instead of static"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-dll" if build.include? 'with-dll'

    cd 'c++' do
      system "./configure", *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--with-dll' will create dynamic binaries instead of
    static. NCBI Blast static binaries are approximately 28-times larger
    than dynamic binaries.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.
    EOS
  end
end

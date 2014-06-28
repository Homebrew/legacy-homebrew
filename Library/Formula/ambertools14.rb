require "formula"

class Ambertools14 < Formula
  homepage "http://ambermd.org"
  url "http://ambermd.rutgers.edu/cgi-bin/AmberTools14-get.pl?Name=homebrewer&Institution=0&City=None&State=Other&Country=INT", :using => :post
  sha1 "342ddaca89369f647fe6df78895584d781719375"
  depends_on 'gcc'
  depends_on 'zlib'
  depends_on :fortran

  option "with-cuda", 'gpu acceleration'
  option "with-mpi", 'compiler directives for parallelization'
  option "with-openmp", 'message passing for parallelization'
  option "with-noX11", 'no graphics'
  option "with-no_macAccelerate", 'no mac-specific speedups'
  option "with-noPatches", "do not use Amber14's recommended patches"

  fails_with :llvm do
      build 2335
      cause <<-EOS.undent
      llvm cannot cross-compile c with fortran in the way amber requires.
      EOS
  end
  fails_with :clang do
      build 2335
      cause <<-EOS.undent
      clang cannot cross-compile c with fortran in the way amber requires.
      EOS
  end

  def install
   for i in 9..4
        i = i.to_s
        puts "/usr/local/bin/gcc-4.#{i}"
        if File.file?("/usr/local/bin/gcc-4.#{i}") and File.file?("/usr/local/bin/g++-4.#{i}")
            ENV['CC'] = "/usr/local/bin/gcc-4.#{i}"
            ENV['CXX'] = "/usr/local/bin/g++-4.#{i}"
            ohai "using gcc version 4.#{i}"
            break
        end
   end
    with_patches = build.with? "noPatches" ? 'n' : 'Y'
    configStr = "export AMBERHOME=`pwd` ; echo #{with_patches} | ./configure"
    configStr += ' -cuda'if build.with? "cuda"
    configStr += ' -mpi'if build.with? "mpi"
    configStr += ' -openmp'if build.with? "openmpi"
    configStr += ' -noX11' if build.with? "noX11"
    configStr += ' -macAccelerate' if build.without? "no_macAccelerate"
    configStr += ' gnu'
    system configStr
    system "export AMBERHOME=`pwd` ; make install"
    ohai "You will want to put 'export AMBERHOME=#{prefix} ' in your shell startup file"

    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
    (prefix/"AmberTools").install Dir["AmberTools/*"]
    (prefix/"test").install Dir["test/*"]
    (prefix/"updateutils").install Dir["updateutils/*"]
  end

  def caveats
      s = <<-EOS.undent
      Compiling amber14 can fail with old versions of gcc. If you get an error message to this effect, try
      executing `export HOMEBREW_CC=<path_to_desired_gcc>` and `export HOMEBREW_CXX=<path_to_desired_g++>`.

      Using ambertools may require the shell variable AMBERHOME to be set to #{prefix}
      If you are compiling with cuda support, the shell variable CUDA_HOME must be set appropriately.
      EOS
      s
  end
end

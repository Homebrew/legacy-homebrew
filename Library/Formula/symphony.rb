require 'formula'

class Symphony < Formula
  homepage 'http://www.coin-or.org/projects/SYMPHONY.xml'
  url 'http://www.coin-or.org/download/source/SYMPHONY/SYMPHONY-5.3.3.tgz'
  md5 '8c34f9fa49ebff325b984408ff1f92fc'

  option "enable-openmp", "Enable openmp support"
  option "with-gmpl", "GNU Modeling Language support via GLPK"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--enable-shared=no", # can't get shared libs to work
            "--enable-static-executable",
            "--prefix=#{prefix}"]

    if build.include? "with-gmpl"
      # Symphony uses a patched version of GLPK for reading MPL files.
      # Use a private version rather than require the Homebrew version of GLPK.
      cd 'ThirdParty/Glpk' do
        system "./get.Glpk"
      end

      ENV.append "CPPFLAGS", "-I#{buildpath}/ThirdParty/Glpk/glpk/src"
      ENV.append "CDEFS", "-DUSE_GLPMPL"
      args << "--with-gmpl"
    end

    if build.include? "enable-openmp"
      inreplace 'SYMPHONY/config', /^SYM_COMPILE_IN_LP = TRUE/, "SYM_COMPILE_IN_LP = FALSE"
      args << "--enable-openmp"
    end

    system "./configure",  *args
    system "make"
    system "make install"
  end
end

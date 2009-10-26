require 'formula'

class GambitScheme <Formula
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.5/source/gambc-v4_5_2.tgz'
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  md5 '71bd4b5858f807c4a8ce6ce68737db16'

  def install
    # Gambit Scheme currently fails to build with llvm-gcc
    # (ld crashes during the build process)
    ENV.gcc_4_2
    # Gambit Scheme will not build with heavy optimizations. Disable all
    # optimizations until safe values can be figured out.
    ENV.no_optimization

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          # Recommended to improve the execution speed and compactness
                          # of the generated executables. Increases compilation times.
                          "--enable-single-host"

    system "make install"
  end
end

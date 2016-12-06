require 'formula'

class Nusmv < Formula
  homepage 'http://nusmv.fbk.eu/'
  url 'http://nusmv.fbk.eu/distrib/NuSMV-2.5.4.tar.gz'
  sha1 '968798a95eac0127e3324dd2dc05bc0ff3ccf2fd'

  depends_on 'cmake' => :build
  depends_on 'wget' => :build

  option 'with-zchaff', 'build the zchaff SAT solver and link against it'

  fails_with :clang do
     build 421
     cause 'MiniSat'
  end

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    cd "MiniSat" do
      system "./build.sh"
    end

    if build.include? 'with-zchaff'
       cd "zchaff" do
         ENV.j1
         system "./build.sh"
       end
       args << "--enable-zchaff"
    end

    if MacOS.prefer_64_bit?
       makefile =  "Makefile_os_x_64bit"
    else
       makefile =  "Makefile_os_x"
    end
    system "make", "-C", "cudd-2.4.1.1", "-f", makefile

    cd "nusmv" do
       system "./configure", *args
       system "make install"
    end
  end
end

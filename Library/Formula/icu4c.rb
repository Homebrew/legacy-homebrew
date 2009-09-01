require 'brewkit'

class Icu4c <Formula
  @url='http://download.icu-project.org/files/icu4c/4.3.1/icu4c-4_3_1-src.tgz'
  @homepage='http://site.icu-project.org/'
  @md5='10d1cdc843f8e047fc308ec49d3d0543'
  @version = "4.3.1"
  
  def patches
    ["http://pastie.org/603488.txt"]
  end
  
  def install
    config_flags = ["--prefix=#{prefix}", "--disable-samples", "--enable-static"]
    config_flags << "--with-library-bits=64" if Hardware.intel_family == :core2 and MACOS_VERSION == 10.6
    Dir.chdir "source" do
      system "./configure", *config_flags
      system "make"
      system "make install"
    end
  end
  
  def caveats
    "ICU doesn't like to build on Snow Leopard with all the heavy CFLAG optimizations, primarily -O3. You may need to change your brewkit environment flags to get it to build on Snow Leopard."
  end
end

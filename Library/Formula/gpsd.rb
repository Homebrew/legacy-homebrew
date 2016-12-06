require 'formula'

class Gpsd < Formula
  url 'http://download.berlios.de/gpsd/gpsd-2.95.tar.gz'
  homepage 'http://gpsd.berlios.de/'
  md5 '12535a9ed9fecf9ea2c5bdc9840da5ae'

  fails_with_llvm

  depends_on 'python'

  skip_clean :all

  def install
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

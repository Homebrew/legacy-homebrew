require 'formula'

class Libbluray < Formula
  url 'git://git.videolan.org/libbluray.git', :commit => "573431998bedeb55e7efd703d72b2986c7dff7eb"
  homepage 'http://www.videolan.org/developers/libbluray.html'
  version '573431998bedeb55e7efd703d72b2986c7dff7eb'

  # We will probably also want to include 'libbdplus' as this is need to decrypt
  # DRMed blueray disks. However I need to first create the formula for it.
  depends_on 'libaacs'

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-examples", "--enable-bdjava",
                          # We need to set the jdk path explicity using the output of the 'java_home' command
                          # as libbluray defaults to "/usr/lib/jvm/java-6-openjdk" which is incorrect for osx
                          "--with-jdk=#{%x(/usr/libexec/java_home).chomp}",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

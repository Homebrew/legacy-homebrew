require 'formula'

class Dc3dd < Formula
  url 'http://downloads.sourceforge.net/project/dc3dd/dc3dd/7.1.0/dc3dd-7.1.614.tar.gz'
  homepage 'http://sourceforge.net/projects/dc3dd/'
  md5 'b6c4ec16e7f539b17224d7f334f8396e'

  def patches
     # remove explicit dependency on automake 1.10.1
    { :p1 => 'https://raw.github.com/gist/1159050/611c91779ba90edc77b8489e006c96a8e0078462/dc3dd-automake.patch'}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make"
    system "make install"
    rm (lib+'charset.alias')
    prefix.install %w[README Options_Reference.txt Sample_Commands.txt]
  end
end

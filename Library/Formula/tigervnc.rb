require 'formula'

class Tigervnc <Formula
  url 'http://netcologne.dl.sourceforge.net/project/tigervnc/tigervnc/1.0.1/tigervnc-1.0.1.tar.gz'
  homepage 'http://tigervnc.org/'
  md5 'daca3eb16afe65253b766eccb8bfdbc5'

  def install
    Dir.chdir "./unix" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end
end

require 'formula'

class Putty < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/putty/'
  url 'http://the.earth.li/~sgtatham/putty/0.63/putty-0.63.tar.gz'
  sha1 '195c0603ef61082b91276faa8d4246ea472bba3b'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+' => :optional

  def install
    cd "unix" do
      system "./configure", "--prefix=#{prefix}", "--disable-gtktest"
      system "make", "VER=-DRELEASE=#{version}"

      bin.install %w{ putty puttytel pterm } if build.with? 'gtk+'
      bin.install %w{ plink pscp psftp puttygen }
    end

    cd "doc" do
      man1.install %w{ putty.1 puttytel.1 pterm.1 } if build.with? 'gtk+'
      man1.install %w{ plink.1 pscp.1 psftp.1 puttygen.1 }
    end
  end
end

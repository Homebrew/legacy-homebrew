require 'formula'

class Putty < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/putty/'
  url 'http://the.earth.li/~sgtatham/putty/0.63/putty-0.63.tar.gz'
  sha256 '81e8eaaf31be7d9a46b4f3fb80d1d9540776f142cd89d0a11f2f8082dc68f8b5'

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

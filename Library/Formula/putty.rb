require 'formula'

class Putty < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/putty/'
  url 'http://the.earth.li/~sgtatham/putty/0.62/putty-0.62.tar.gz'
  sha1 '5898438614117ee7e3704fc3f30a3c4bf2041380'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+' => :optional

  def install
    cd "unix" do
      system "./configure", "--prefix=#{prefix}", "--disable-gtktest"
      system "make", "VER=-DRELEASE=#{version}",
                     (build.with?('gtk+') ? "all" : "all-cli")

      bin.install %w{ putty puttytel pterm } if build.with? 'gtk+'
      bin.install %w{ plink pscp psftp puttygen }
    end

    cd "doc" do
      man1.install %w{ putty.1 puttytel.1 pterm.1 } if build.with? 'gtk+'
      man1.install %w{ plink.1 pscp.1 psftp.1 puttygen.1 }
    end
  end
end

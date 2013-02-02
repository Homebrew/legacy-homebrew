require 'formula'

class Putty < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/putty/'
  url 'http://the.earth.li/~sgtatham/putty/0.62/putty-0.62.tar.gz'
  sha1 '5898438614117ee7e3704fc3f30a3c4bf2041380'

  depends_on 'gtk+'

  def install
    # use the unix build to make all PuTTY gui and command line tools
    cd "unix" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "VER=-DRELEASE=#{version}", "all"
      # install manually
      bin.install %w{ pterm putty puttytel plink pscp psftp puttygen }
    end
    cd "doc" do
      man1.install %w{ pterm.1 putty.1 puttytel.1 plink.1 pscp.1 psftp.1 puttygen.1 }
    end
  end
end

require 'formula'

class Putty < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/putty/'
  url 'http://the.earth.li/~sgtatham/putty/0.62/putty-0.62.tar.gz'
  sha1 '5898438614117ee7e3704fc3f30a3c4bf2041380'

  option 'with-gtk+', 'Build with GUI parts of PuTTY that require GTK+'

  depends_on 'gtk+' => :optional if build.include? "with-gtk+"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-gtktest" unless build.include? 'with-gtk+'
    args << "--with-gtk-prefix=/dev/null" unless build.include? 'with-gtk+'

    # use the unix build to make all PuTTY  tools
    cd "unix" do
      system "./configure", *args

      system "make", "VER=-DRELEASE=#{version}",
      if build.include? 'with-gtk+'
        "all"
      else
        "all-cli"
      end

      bin.install %w{ putty puttytel pterm } if build.include? 'with-gtk+'
      bin.install %w{ plink pscp psftp puttygen }
    end

    cd "doc" do
      man1.install %w{ putty.1 puttytel.1 pterm.1 } if build.include? 'with-gtk+'
      man1.install %w{ plink.1 pscp.1 psftp.1 puttygen.1 }
    end

  end
end

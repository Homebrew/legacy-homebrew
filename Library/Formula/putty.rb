require "formula"

class Putty < Formula
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "http://the.earth.li/~sgtatham/putty/0.63/putty-0.63.tar.gz"
  sha1 "195c0603ef61082b91276faa8d4246ea472bba3b"

  head do
    url "svn://svn.tartarus.org/sgt/putty"
    depends_on "halibut" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+" => :optional

  def install
    if build.head?
      system "./mkfiles.pl"
      system "./mkauto.sh"
      system "make", "-C", "doc"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-gtktest"

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w{ putty puttytel pterm } if build.with? "gtk+"
    bin.install %w{ plink pscp psftp puttygen }

    cd "doc" do
      man1.install %w{ putty.1 puttytel.1 pterm.1 } if build.with? "gtk+"
      man1.install %w{ plink.1 pscp.1 psftp.1 puttygen.1 }
    end
  end
end

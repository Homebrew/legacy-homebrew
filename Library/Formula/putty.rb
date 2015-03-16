class Putty < Formula
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.64/putty-0.64.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.64.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.64.tar.gz"
  sha256 "2a46c97a184144e3ec2392aca9acc64d062317a3a38b9a5f623a147eda5f3821"

  bottle do
    cellar :any
    sha1 "e556bd7b79a16a7f002558d29d1ee2c32cea10eb" => :yosemite
    sha1 "2d936017216448550b014391e7063fadd6545dbe" => :mavericks
    sha1 "dba2d463ddcde5b15f0d0d06e18935c3a6465fd7" => :mountain_lion
  end

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

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-gtktest
    ]
    args << ((build.with? "gtk+") ? "--with-gtk" : "--without-gtk")

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[putty puttytel pterm] if build.with? "gtk+"
    bin.install %w[plink pscp psftp puttygen]

    cd "doc" do
      man1.install %w[putty.1 puttytel.1 pterm.1] if build.with? "gtk+"
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
    end
  end
end

class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.64/putty-0.64.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.64.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.64.tar.gz"
  sha256 "2a46c97a184144e3ec2392aca9acc64d062317a3a38b9a5f623a147eda5f3821"

  bottle do
    cellar :any
    sha256 "1544c89c1a77addd9ca1b3976e29c7d2b0dab05728d69bc8a49ec43c3a6c1058" => :yosemite
    sha256 "780b82f548d3f66b892470be198ca9f3ba7ceaa8440b46c2993d24e58c20ed6a" => :mavericks
    sha256 "ea7a2ecaf3ba3c5dcfbaccfecd7c3062a36d5eb80f86ae0084c3df23deef55f8" => :mountain_lion
  end

  head do
    url "svn://svn.tartarus.org/sgt/putty"
    depends_on "halibut" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build

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
      --without-gtk
    ]

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
    end
  end
end

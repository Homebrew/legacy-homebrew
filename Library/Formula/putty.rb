class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.66/putty-0.66.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.66.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.66.tar.gz"
  sha256 "fe7312f66c54865868b362f4b79bd1fbe7ce9e8b1fd504b04034182db1f32993"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e5da01a4f37e647305cc87c5575c0cc028ea11661558cd47e4563876a52b17f" => :el_capitan
    sha256 "b076e4778143be23784e906689e7fc687073d2120fedf89fedc0a950f5ee69be" => :yosemite
    sha256 "60d408eac949404d999cdd12fb9045516c03dce628b091e6379593ae3ecbc76c" => :mavericks
  end

  conflicts_with "pssh", :because => "both install `pscp` binaries"

  head do
    url "git://git.tartarus.org/simon/putty.git"

    depends_on "halibut" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk+3" => :optional
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
    ]

    if build.head? && build.with?("gtk+3")
      args << "--with-gtk=3" << "--with-quartz"
    else
      args << "--without-gtk"
    end

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]
    bin.install %w[putty puttytel pterm] if build.head? && build.with?("gtk+3")

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
      man1.install %w[putty.1 puttytel.1 pterm.1] if build.head? && build.with?("gtk+3")
    end
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert File.exist?("test.key")
  end
end

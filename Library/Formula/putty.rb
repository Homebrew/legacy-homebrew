class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.67/putty-0.67.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.67.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.67.tar.gz"
  sha256 "80192458e8a46229de512afeca5c757dd8fce09606b3c992fbaeeee29b994a47"

  bottle do
    cellar :any_skip_relocation
    sha256 "36280287489637eebb3b5994ad0ec4821e7cb0705a4ca109dd1d3ddb40e2f6bf" => :el_capitan
    sha256 "132fd31add6b21cc25bb79f778c48ce004c236d18ea99e22acc8a8d1ad51e819" => :yosemite
    sha256 "066385a68e8c73e006f886930a267899eb02da47b8802b17c8f9cfe1263a45b6" => :mavericks
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

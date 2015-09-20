class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.65/putty-0.65.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.65.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.65.tar.gz"
  sha256 "d543c1fd4944ea51d46d4abf31bfb8cde9bd1c65cb36dc6b83e51ce875660ca0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e5da01a4f37e647305cc87c5575c0cc028ea11661558cd47e4563876a52b17f" => :el_capitan
    sha256 "b076e4778143be23784e906689e7fc687073d2120fedf89fedc0a950f5ee69be" => :yosemite
    sha256 "60d408eac949404d999cdd12fb9045516c03dce628b091e6379593ae3ecbc76c" => :mavericks
  end

  conflicts_with "pssh", :because => "both install `pscp` binaries"

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

  test do
    (testpath/"testing/command.sh").write <<-EOS.undent
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
    chmod 0755, testpath/"testing/command.sh"

    cd "testing" do
      system "./command.sh"
      assert File.exist?("test.key")
    end
  end
end

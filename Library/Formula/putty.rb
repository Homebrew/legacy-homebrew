class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.64/putty-0.64.tar.gz"
  mirror "https://fossies.org/linux/misc/putty-0.64.tar.gz"
  mirror "ftp://ftp.chiark.greenend.org.uk/users/sgtatham/putty-latest/putty-0.64.tar.gz"
  sha256 "2a46c97a184144e3ec2392aca9acc64d062317a3a38b9a5f623a147eda5f3821"

  bottle do
    cellar :any
    revision 1
    sha256 "23ea6a1e7979ebdd4891ff1968e444a14d4cdd02ab36762df8192c654e796bca" => :yosemite
    sha256 "0aca10188a1a172c09fff6d9d1669e08ad1afd34a0a84b8c4798e83bdb1895d4" => :mavericks
    sha256 "0c3d48155005e602a8c278b9df98d8c2d7df3464c39207b72bbcfdcc0ac6fb83" => :mountain_lion
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

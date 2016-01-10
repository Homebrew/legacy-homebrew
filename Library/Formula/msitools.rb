class Msitools < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/msitools/0.94/msitools-0.94.tar.xz"
  sha256 "152eb4149cb44f178af93d17bbe0921b5312f30fb4780e5be113b35747b5cd2e"

  bottle do
    sha256 "cdca1a71f773df3e0f9b011c96d0bc7f111802ef59fc23911cb311fcb1c5bbfc" => :yosemite
    sha256 "49b08369397ee127391c04899faec0cfe667c655e31578f7b1138c08eb016982" => :mavericks
    sha256 "ce0f1a31f98f3565b739bd11ed4b7b64a97a81bded5ff22bd82987ac0813d63b" => :mountain_lion
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgsf"
  depends_on "vala"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # wixl-heat: make an xml fragment
    assert_match /<Fragment>/, pipe_output("#{bin}/wixl-heat --prefix test")

    # wixl: build two installers
    1.upto(2) do |i|
      (testpath/"test#{i}.txt").write "abc"
      (testpath/"installer#{i}.wxs").write <<-EOS.undent
        <?xml version="1.0"?>
        <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
           <Product Id="*" UpgradeCode="DADAA9FC-54F7-4977-9EA1-8BDF6DC73C7#{i}"
                    Name="Test" Version="1.0.0" Manufacturer="BigCo" Language="1033">
              <Package InstallerVersion="200" Compressed="yes" Comments="Windows Installer Package"/>
              <Media Id="1" Cabinet="product.cab" EmbedCab="yes"/>

              <Directory Id="TARGETDIR" Name="SourceDir">
                 <Directory Id="ProgramFilesFolder">
                    <Directory Id="INSTALLDIR" Name="test">
                       <Component Id="ApplicationFiles" Guid="52028951-5A2A-4FB6-B8B2-73EF49B320F#{i}">
                          <File Id="ApplicationFile1" Source="test#{i}.txt"/>
                       </Component>
                    </Directory>
                 </Directory>
              </Directory>

              <Feature Id="DefaultFeature" Level="1">
                 <ComponentRef Id="ApplicationFiles"/>
              </Feature>
           </Product>
        </Wix>
      EOS
      system "#{bin}/wixl", "-o", "installer#{i}.msi", "installer#{i}.wxs"
      assert File.exist?("installer#{i}.msi")
    end

    # msidiff: diff two installers
    lines = `#{bin}/msidiff --list installer1.msi installer2.msi 2>/dev/null`.split("\n")
    assert_equal 0, $?.exitstatus
    assert_equal "-Program Files/test/test1.txt", lines[-2]
    assert_equal "+Program Files/test/test2.txt", lines[-1]

    # msiinfo: show info for an installer
    out = `#{bin}/msiinfo suminfo installer1.msi`
    assert_equal 0, $?.exitstatus
    assert_match /Author: BigCo/, out

    # msiextract: extract files from an installer
    mkdir "files"
    system "#{bin}/msiextract", "--directory", "files", "installer1.msi"
    assert_equal (testpath/"test1.txt").read,
                 (testpath/"files/Program Files/test/test1.txt").read

    # msidump: dump tables from an installer
    mkdir "idt"
    system "#{bin}/msidump", "--directory", "idt", "installer1.msi"
    assert File.exist?("idt/File.idt")

    # msibuild: replace a table in an installer
    system "#{bin}/msibuild", "installer1.msi", "-i", "idt/File.idt"
  end
end

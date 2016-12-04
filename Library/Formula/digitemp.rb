class Digitemp < Formula
  desc "Read temperature sensors in a 1-Wire net"
  homepage "https://www.digitemp.com/"
  url "https://www.digitemp.com/software/linux/digitemp-3.6.0.tar.gz"
  sha256 "14cfc584cd3714fe8c9a2cdc8388be49e08b5e395d95e6bcd11d4410e2505ca2"

  depends_on "libusb-compat"

  # DigiTemp upstream development is effective dark.  Patches from the
  # digitemp-pkg-debian repo are from the Debian package's patchset, but
  # are not specific to Debian.

  # Fix incorrect version number in banner
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-banner-version.patch"
    sha256 "fc7a0de6720d3e2c94541ff5d96fd96b3d9388554ea5bd818b7fe01d56510a67"
  end

  # Spelling corrections in binary code
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-code-spelling.patch"
    sha256 "cdcbd1818304a7fc7e7b54d14b953d6cc8c9d375bb9b6bb315aeafb5cff0f444"
  end

  # Change /dev max name length from 40 (39) chars to 1024 (1023)
  # https://bugs.launchpad.net/bugs/978294
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-devlength.patch"
    sha256 "90bcedb958eefe724795a72370db7cd5a16c424bd35e1737921f07d11ce5dc86"
  end

  # Makefile adjustments (allow for compiling all 3 variants from the
  # same source extract, specifying CFLAGS/LDFLAGS, etc)
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-makefile.patch"
    sha256 "644a05e111f6918548532ea3915261adde8207a2166095ed22b2d3909fcf80ce"
  end

  # Flush logs when running non-interactive
  # http://bugs.debian.org/691069
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-flush-stdout.patch"
    sha256 "bc2c669875f1685e47273839432fd8a6ffe8499b90cb431782cc540c5c21fd6d"
  end

  # Correct errors caught by -Werror=format-security
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-format-security.patch"
    sha256 "ab5a3f1fd8f760762e887ae821b519229ef1609a70626452e77d03ec7e64479c"
  end

  # Replace lockdev usage with flock
  # http://bugs.debian.org/728018
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-flock.patch"
    sha256 "15686de961609e3f2b9b0e2b1417f13ab538cb342e639861794139806e757ff7"
  end

  # Fix SetBaudCOM conflicting parameter types
  # http://bugs.debian.org/748036
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-setbaudcom.patch"
    sha256 "1714c5db88f78492c36d87d08d12e06c888d8fe8472a4f2562087e57c416c6aa"
  end

  # Properly reset the 1-Wire bus on DS2490
  # https://bugs.launchpad.net/bugs/1397382
  patch do
    url "https://raw.githubusercontent.com/rfinnie/digitemp-pkg-debian/68ffe2b2800acd37f75a24b7adb5848964a54d08/patches/digitemp-3.6.0+dfsg1-usb-reset-status.patch"
    sha256 "56294a69f8a92148be7c265f32b7950c1805cff75c5696b109a0708848e1f9bf"
  end

  def install
    mkdir_p "build-serial/src"
    mkdir_p "build-serial/userial/ds9097"
    mkdir_p "build-serial/userial/ds9097u"
    mkdir_p "build-usb/src"
    mkdir_p "build-usb/userial/ds2490"
    system "make", "-C", "build-serial", "-f", "../Makefile", "SRCDIR=..", "ds9097", "ds9097u"
    system "make", "-C", "build-usb", "-f", "../Makefile", "SRCDIR=..", "ds2490"
    bin.install "build-serial/digitemp_DS9097"
    bin.install "build-serial/digitemp_DS9097U"
    bin.install "build-usb/digitemp_DS2490"
    man1.install "digitemp.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097U.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS2490.1"
  end

  # digitemp has no self-tests and does nothing without a 1-wire device,
  # so at least check the individual binaries compiled to what we expect.
  test do
    assert_equal "Compiled for DS2490",
      shell_output("#{bin}/digitemp_DS2490 2>/dev/null | head -n 3 | tail -n 1").chomp
  end
  test do
    assert_equal "Compiled for DS9097",
      shell_output("#{bin}/digitemp_DS9097 2>/dev/null | head -n 3 | tail -n 1").chomp
  end
  test do
    assert_equal "Compiled for DS9097U",
      shell_output("#{bin}/digitemp_DS9097U 2>/dev/null | head -n 3 | tail -n 1").chomp
  end
end

class Patchelf < Formula
  desc "PatchELF: modify the dynamic linker and RPATH of ELF executables"
  homepage "https://nixos.org/patchelf.html"
  # tag "linuxbrew"

  url "http://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.bz2"
  sha256 "c99f84d124347340c36707089ec8f70530abd56e7827c54d506eb4cc097a17e7"

  bottle do
    cellar :any
    sha256 "c6bab9c75be8610cc9875a2b269850de5c98ff65ae2a5d8b6bbf9ca153652c5e" => :x86_64_linux
  end

  head do
    url "https://github.com/NixOS/patchelf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-static", "Link statically"
  option "without-static-libstdc++", "Link libstdc++ dynamically"

  def install
    # Fix ./configure: line 4: .: filename argument required
    inreplace "configure.ac", "m4_esyscmd([echo -n $(cat ./version)])", version

    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
      ("CXXFLAGS=-static" if build.with? "static"),
      ("CXXFLAGS=-static-libgcc -static-libstdc++" if build.with? "static-libstdc++"),
      "--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/patchelf", "--version"
  end
end

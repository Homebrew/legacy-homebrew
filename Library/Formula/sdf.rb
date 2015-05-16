require "formula"

class Sdf < Formula
  homepage "http://strategoxt.org/Sdf/WebHome"
  url "http://www.meta-environment.org/releases/sdf-2.6.3.tar.gz"
  sha1 "98cb63cf9ed9e1b51727f55963dad31615f75b0d"

  bottle do
    sha1 "86d9132aa6d0b168265486619986905f5e4d934e" => :mavericks
    sha1 "84b6e3fefe67faad2f0e6e4a407f9323a6eaf9d5" => :mountain_lion
    sha1 "8ff0e900e359df0e0fca16b686f87a201d10a5d2" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "aterm"

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      ParsedError.c:15434:611: fatal error: parser recursion
      limit reached, program too complex
    EOS
  end

  resource "c-library" do
    url "http://www.meta-environment.org/releases/c-library-1.2.tar.gz"
    sha1 "2c9fa849c2bf7a96c4614d6532da20a399c730c1"
  end

  resource "toolbuslib" do
    url "http://www.meta-environment.org/releases/toolbuslib-1.1.tar.gz"
    sha1 "2f34935a34fa363c8c11d2c646ae78e5553db6d9"
  end

  resource "error-support" do
    url "http://www.meta-environment.org/releases/error-support-1.6.tar.gz"
    sha1 "003bc4569a3a67fb196f96a1229f532c127a9d30"
  end

  resource "pt-support" do
    url "http://www.meta-environment.org/releases/pt-support-2.4.tar.gz"
    sha1 "84969166e0fba9108d015ae524f351517707dde1"
  end

  resource "sdf-support" do
    url "http://www.meta-environment.org/releases/sdf-support-2.5.tar.gz"
    sha1 "d079f7693234bdb5c82104800049836a9b0e0bd4"
  end

  resource "asf-support" do
    url "http://www.meta-environment.org/releases/asf-support-1.8.tar.gz"
    sha1 "bf3eb12f8992c250ce208c059b5c5cef0a29c6b9"
  end

  resource "tide-support" do
    url "http://www.meta-environment.org/releases/tide-support-1.3.1.tar.gz"
    sha1 "201cb8c65256f149c820d65d1e4a849404e7d039"
  end

  resource "rstore-support" do
    url "http://www.meta-environment.org/releases/rstore-support-1.0.tar.gz"
    sha1 "22ce248db8e81aad5866512c94296cba6c4c5cf5"
  end

  resource "config-support" do
    url "http://www.meta-environment.org/releases/config-support-1.4.tar.gz"
    sha1 "7b6b530562a6a4befbcc190cd74ad3f2257d8353"
  end

  resource "ptable-support" do
    url "http://www.meta-environment.org/releases/ptable-support-1.2.tar.gz"
    sha1 "2f868e1f9ff3ccc71f173e4cf40f30e31f648ef8"
  end

  resource "sglr" do
    url "http://www.meta-environment.org/releases/sglr-4.5.3.tar.gz"
    sha1 "a92b73ee94bc55a657136bf1895393bfc2512a99"
  end

  resource "asc-support" do
    url "http://www.meta-environment.org/releases/asc-support-2.6.tar.gz"
    sha1 "76ff3c3a655498ef8e8fcc533164d492ff16503a"
  end

  resource "pgen" do
    url "http://www.meta-environment.org/releases/pgen-2.8.1.tar.gz"
    sha1 "56b3c915dd8e1cbadef5beec3ef9c11a80211445"
  end

  resource "pandora" do
    url "http://www.meta-environment.org/releases/pandora-1.6.tar.gz"
    sha1 "0cfb1de5ea8feba43002486286ff140c060e1cc4"
  end

  def install
    ENV.j1 # build is not parallel-safe
    ENV.append "CFLAGS", "-std=gnu89 -fbracket-depth=1024" if ENV.compiler == :clang

    resource("c-library").stage do
      system "./configure", "--prefix=#{libexec}/c-library"
      system "make install"
    end

    resource("toolbuslib").stage do
      system "./configure", "--prefix=#{libexec}/toolbuslib"
      system "make install"
    end

    resource("error-support").stage do
      system "./configure", "--prefix=#{libexec}/error-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make install"
    end

    resource("pt-support").stage do
      system "./configure", "--prefix=#{libexec}/pt-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support"
      system "make install"
    end

    resource("sdf-support").stage do
      system "./configure", "--prefix=#{libexec}/sdf-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make install"
    end

    resource("asf-support").stage do
      system "./configure", "--prefix=#{libexec}/asf-support",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make install"
    end

    resource("tide-support").stage do
      system "./configure", "--prefix=#{libexec}/tide-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make install"
    end

    resource("rstore-support").stage do
      system "./configure", "--prefix=#{libexec}/rstore-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib"
      system "make install"
    end

    resource("config-support").stage do
      system "./configure", "--prefix=#{libexec}/config-support"
      system "make install"
    end

    resource("ptable-support").stage do
      system "./configure", "--prefix=#{libexec}/ptable-support",
                            "--with-pt-support=#{libexec}/pt-support"
      system "make install"
    end

    resource("sglr").stage do
      system "./configure", "--prefix=#{libexec}/sglr",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library"
      system "make install"
    end

    resource("asc-support").stage do
      system "./configure", "--prefix=#{libexec}/asc-support",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library",
                            "--with-tide-support=#{libexec}/tide-support",
                            "--with-rstore-support=#{libexec}/rstore-support",
                            "--with-asf-support=#{libexec}/asf-support",
                            "--with-rstore-support=#{libexec}/rstore-support",
                            "--with-sglr=#{libexec}/sglr"
      system "make install"
    end

    resource("pgen").stage do
      system "./configure", "--prefix=#{libexec}/pgen",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-error-support=#{libexec}/error-support",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-ptable-support=#{libexec}/ptable-support",
                            "--with-config-support=#{libexec}/config-support",
                            "--with-c-library=#{libexec}/c-library",
                            "--with-sglr=#{libexec}/sglr",
                            "--with-sdf-support=#{libexec}/sdf-support",
                            "--with-asc-support=#{libexec}/asc-support"
      system "make install"
    end

    resource("pandora").stage do
      system "./configure", "--prefix=#{libexec}/pandora",
                            "--with-toolbuslib=#{libexec}/toolbuslib",
                            "--with-pt-support=#{libexec}/pt-support",
                            "--with-asc-support=#{libexec}/asc-support"
      system "make install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-sglr=#{libexec}/sglr",
                          "--with-pgen=#{libexec}/pgen",
                          "--with-pandora=#{libexec}/pandora"
    system "make install"
  end
end

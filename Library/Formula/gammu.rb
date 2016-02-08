class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.37.0.orig.tar.xz"
  sha256 "f0a597be5c5138691606b78a82a17c76769c6ed445b4b541fcc06520f3bea61f"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "3326021179a308021ef03127af4b9d051530686d1f5dc3e84c3640b4b82542d7" => :yosemite
    sha256 "25a1340421feced88e1bb8ae810a26dfd7f2bf4a7f30c48d148874208cd8875a" => :mavericks
    sha256 "3509f63360d9e7417cdf692c7296c1b386e4cba78d758ad5b56ad6e0be0c450f" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "gettext" => :optional
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end

class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "http://wammu.eu/gammu/"
  head "https://github.com/gammu/gammu.git"

  stable do
    url "http://dl.cihar.com/gammu/releases/gammu-1.36.5.tar.xz"
    mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.36.5.orig.tar.xz"
    sha256 "42e626f8f8b97c7a0afc5547a6056aa061725e8e3ace91dbcf9e83816a70ab86"

    # To customize bash completion location; remove in next stable release
    patch do
      url "https://github.com/gammu/gammu/commit/470c53aa640f5c53671ae22e06a7159f39774042.diff"
      sha256 "ed3a402f36a8314a1a3df187827988ed8f5c9a5638397fe684ed4f0ed5ffbf44"
    end
  end

  bottle do
    sha256 "c5e3744176b3609902070f07ced499d02570a8dc0d5aa72e02383b8e9bcce5a4" => :yosemite
    sha256 "106312958bcfb95929178a716ca5cd458ee37ba9e6ad6ca80ba3dbb0ac8c8b40" => :mavericks
    sha256 "d1f54aae239138586fbc5693120a28b58eb709811461478b8dc976345b3de3df" => :mountain_lion
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

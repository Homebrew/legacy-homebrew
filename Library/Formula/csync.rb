class Csync < Formula
  desc "File synchronizer especially designed for normal users"
  homepage "https://www.csync.org/"
  url "https://open.cryptomilk.org/attachments/download/27/csync-0.50.0.tar.xz"
  sha1 "8df896be17f7f038260159469a6968a9d563cb3c"

  head "git://git.csync.org/projects/csync.git"

  bottle do
    sha1 "c7934c397dc23b7f91bc73da7fc2a1086caf0644" => :yosemite
    sha1 "4678a5c8787a3ef569ec8bc3ae62dbc011aa67dd" => :mavericks
    sha1 "a47861728aa4d4cb4c26423afcc45ae942a415e5" => :mountain_lion
  end

  depends_on 'check' => :build
  depends_on 'cmake' => :build
  depends_on 'doxygen' => [:build, :optional]
  depends_on 'argp-standalone'
  depends_on 'iniparser'
  depends_on 'sqlite'
  depends_on 'libssh' => :optional
  depends_on 'log4c' => :optional
  depends_on 'samba' => :optional

  depends_on :macos => :lion

  def install
    mkdir "build" unless build.head?
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
  end

  test do
    system bin/"csync", "-V"
  end
end

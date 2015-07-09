class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "http://vifm.info/"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.8.tar.bz2"
  mirror "https://github.com/vifm/vifm/releases/download/v0.8/vifm-0.8.tar.bz2"
  sha256 "69eb6b50dcf462f4233ff987f0b6a295df08a27bc42577ebef725bfe58dbdeeb"

  head do
    url "https://github.com/vifm/vifm.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    sha1 "9c91b72060c3fb9abf43cecc1a2304816deb0334" => :yosemite
    sha1 "f6adc73279074c20f52dcb355bff076bf31cca40" => :mavericks
    sha1 "cc3f9c80da284c39c2460f81eb53ec9bc98ccded" => :mountain_lion
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /^Version: #{Regexp.escape(version)}/,
      shell_output("#{bin}/vifm --version")
  end
end

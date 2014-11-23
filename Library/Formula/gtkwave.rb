require "formula"

class Gtkwave < Formula
  homepage "http://gtkwave.sourceforge.net/"
  # 3.3.63 is the latest, but everything over 3.3.60 refuses to compile.
  # Bug report filed upstream at bybell@rocketmail.com on 23/11/14
  url "http://gtkwave.sourceforge.net/gtkwave-3.3.60.tar.gz"
  sha1 "040894bd142623b1bb9d7000619e9787a6db3f76"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "xz" # For LZMA support
  depends_on :x11

  def install
    args = [ "--disable-dependency-tracking",
             "--disable-silent-rules",
             "--prefix=#{prefix}"
    ]

    unless MacOS::CLT.installed?
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
      args << "--with-tk=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gtkwave", "--version"
  end
end

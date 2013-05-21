require 'formula'
require 'iconv'

class Gforth < Formula
  homepage 'http://bernd-paysan.de/gforth.html'
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.2.tar.gz'
  sha1 'fe662c60b74290b08b6245816b68faed2a1e5c20'

  depends_on :libtool
  depends_on 'libffi'
  depends_on 'pcre'
  depends_on 'texi2html' => :build

  def darwin_major_version
    # kern.osrelease: 11.4.2
    full_version = `/usr/sbin/sysctl -n kern.osrelease`
    full_version.split("\.")[0]
  end

  def install
    ENV.j1 # Parallel builds won't work
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if MacOS.prefer_64_bit?
      args << "--build=x86_64-apple-darwin#{darwin_major_version}"
    end

    # Convert AUTHORS to UTF-8
    authors = ""
    File.open('AUTHORS', 'rb') { |f| authors = f.read }
    authors = Iconv.conv('UTF-8', 'ISO-8859-1', authors)
    File.open('AUTHORS', 'wb') { |f| f.write(authors) }

    system "./configure", *args
    system "make" # Separate build steps.
    system "make doc/gforth"
    system "make install"
    # make install doesn't automatically copy documentation.
    (doc+"html").install Dir.glob('doc/gforth/*')
    doc.install Dir.glob('doc/*.ps')
  end
end

class LibodbQt < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-qt-2.4.0.tar.gz"
  sha256 "f48c563f653df178866301e4c5069b09b697d98f54dcc9ef8714157002156183"

  depends_on "libodb" => :recommended
  option "without-libodb", "Don't install libodb"
  depends_on "qt" => :optional
  option "with-qt", "Install the qt library"

  def install
    qmake = `which qmake`.strip

    if qmake.empty?
      qmake = "#{ENV["QMAKE"]}"
      if qmake.empty?
        onoe "    You need to indicate \`qmake\` path to homebrew as:
             QMAKE=~/Qt/5.4/clang_64/bin/qmake brew install libodb-qt".undent
        exit 1
      end
    end

    qtlib = `#{qmake} -v | tail -n1 | cut -d' ' -f6`.strip

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CPPFLAGS=-F#{qtlib}",
                          "LDFLAGS=-F#{qtlib} -L/usr/lib",
                          "CC=clang", "CXX=clang++ -stdlib=libstdc++",
                          "LIBS=-lstdc++"
    system "make", "install"

    if File.file?(etc/"odb/default.options")
      File.open(etc/"odb/default.options", "a") do |f|
        f << "\n"
        f << "-x -I#{HOMEBREW_PREFIX}/include\n"
        f << "-x -F#{qtlib}\n"
        f << "-x -I#{qtlib}/QtCore.framework/Headers\n"
        f << "-x -I#{qtlib}/QtGui.framework/Headers\n"
        f << "-x -I#{qtlib}/QtWidgets.framework/Headers\n"
      end

      opoo "libodb-* packages must be build with the same compiler your app is.\
      This package assumes your app is built with \"clang\".".undent
    end
  end

  test do
    system "true"
  end
end

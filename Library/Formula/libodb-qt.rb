class LibodbQt < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/libodb-qt-2.4.0.tar.gz"
  sha256 "f48c563f653df178866301e4c5069b09b697d98f54dcc9ef8714157002156183"

  option "without-qt", "Don't install the Qt library"
  option "with-qt5", "Install version 5 of the framework instead of 4."

  if build.with?("qt5")
    depends_on "qt5"
  elsif build.with?("qt")
    depends_on "qt"
  end

  def install
    qmake = "#{ENV["QMAKE"]}"

    if qmake.empty?
      qmake = `which qmake`.strip
      if qmake.empty?
        onoe "    Qt is a dependency, but you chose \"--without-qt\".
             You need to indicate \`qmake\` path to homebrew as:
             QMAKE=~/Qt/5.4/clang_64/bin/qmake brew install libodb-qt".undent
        exit 1
      end
    end

    qtlib = `#{qmake} -v | tail -n1 | cut -d' ' -f6`.strip

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CPPFLAGS=-F#{qtlib}",
                          "LDFLAGS=-F#{qtlib}",
                          "CXX=#{ENV.cxx} -stdlib=libstdc++",
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

      opoo "libodb must be built with the same compiler your executable will be.
This packages is compiled with \"#{ENV.cxx}\", so we assume your app will also be."
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <odb/qt/exception.hxx>
      struct qt_exception : odb::qt::exception
      {
        virtual const char*
        what () const throw () {return 0;};

        virtual qt_exception*
        clone () const {return 0;}
      };

      int main()
      {
        try {
          throw qt_exception();
        } catch (const qt_exception &e) {}
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lodb-qt", "-lodb"
    system "./test"
  end
end

class Odb < Formula
  homepage "http://www.codesynthesis.com/products/odb/"
  url "http://www.codesynthesis.com/download/odb/2.4/odb-2.4.0.tar.gz"
  sha256 "169103a7829b9d8b2fdf5c267d18acc3d47c964d355c7af335d75c63b29c52b5"

  depends_on "gcc"
  depends_on "libcutl"
  depends_on "libodb"

  fails_with :clang do
    cause "ODB is a GCC plugin, therefore must be built with gcc"
  end

  fails_with :llvm do
    cause "ODB is a GCC plugin, therefore must be built with gcc"
  end

  def install
    File.open("doc/default.options", "w") do |f|
      f << "# Default ODB options file. This file is automatically loaded by the ODB\n"
      f << "# compiler and can be used for installation-wide customizations, such as\n"
      f << "# adding an include search path for a commonly used library. For example:\n"
      f << "#\n"
      f << "# -I /opt/boost_1_45_0\n"
      f << "#\n"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{lib}",
                          "--with-options-file=#{prefix}/etc/odb/default.options",
                          "CXXFLAGS=-fno-devirtualize"
    system "make", "install"

    (prefix/"etc/odb").install "doc/default.options"
  end

  test do
    (testpath/"test.hxx").write <<-EOS.undent
    #include <odb/core.hxx>
    #pragma db object
    class person
    {
      private:
      #pragma db id auto
      unsigned long id_;
      unsigned short age_;

      friend class odb::access;
      person(){}

      public:
      person (unsigned short age):age_(age){}

      unsigned short age()const{return age_;}

      void age(unsigned short age){age_=age;}
    };
    EOS
    system "odb", "-d", "sqlite", "-s", "-q", "test.hxx"
  end
end

class LibodbSqlite < Formula
  homepage "http://www.codesynthesis.com/products.odb"
  url "http://www.codesynthesis.com/download/odb/2.3/libodb-sqlite-2.3.0.tar.bz2"
  sha1 "512a124e0b78ae36deee25d595e3e169bd24d216"

  depends_on "sqlite"
  depends_on "odb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

    test do
    (testpath/'person.hxx').write <<-EOS.undent
      #include <odb/core.hxx>     
      #pragma db object           
      class person
      {
      private:
        friend class odb::access; 
        #pragma db id auto
        unsigned long id_;        
      };
    EOS

    (testpath/'main.cxx').write <<-EOS.undent
      #include <iostream>
      int main()
      {
        return 0;
      }
    EOS

    system "odb", "-I#{HOMEBREW_PREFIX}/include", "-m", "dynamic", "-d", "common", "--generate-query", "person.hxx"
    system "#{ENV.cxx}", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/sqlite/lib", "main.cxx", "person-odb.cxx", "-lodb", "-lsqlite3", "-lodb-sqlite", "-o", "person"
    system "./person"
  end
  
end

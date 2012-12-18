require 'formula'

class Libopkele < Formula
  url 'http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2'
  homepage 'http://kin.klever.net/libopkele/'
  sha1 '0c403d118efe6b4ee4830914448078c0ee967757'
  head 'https://github.com/hacker/libopkele.git'

  depends_on 'pkg-config' => :build

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In file included from discovery.cc:5:
      ../include/opkele/discovery.h:24:11: error: use of undeclared identifier 'insert'
                              return insert(typename map_type::value_type(priority,d))->second;
                                     ^
                                     this->
    EOS
  end if !build.head?

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.bash" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

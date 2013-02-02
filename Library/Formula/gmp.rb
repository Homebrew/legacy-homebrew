require 'formula'
class Gmp < Formula
                                                                             
 homepage 'http://gmplib.org/'  
 url 'ftp://ftp.gmplib.org/pub/gmp-5.1.0/gmp-5.1.0.tar.bz2'
 mirror 'http://fossies.org/unix/misc/gmp-5.1.0.tar.bz2'
 sha256 'dfd9aba98fe5caa54a715b4584c7d45eb0ee0c8be9a3181164ad2fad5eefc796'   

 option '32-bit'
 option 'disable-assembly', 'Disable assembly code optimization. Much slower.'
 option 'disable-shared', 'Do not build dylibs.'
 option 'enable-static', 'Build static libraries (as well). No need usually.'

 def install
  args = ["--prefix=#{prefix}"] 
  args << '--enable-cxx'      unless build.include? 'disable-cxx'
  args << '--disable-static'  unless build.include? 'enable-static'
  args << '--disable-shared'      if build.include? 'disable-shared'
  args << '--disable-assembly'    if build.include? 'disable-assembly'

  ENV.deparallelize # is, unfortuately, needed. The problem is somewhere between
                    # autoenv and libtool, though who's but it is, hard to say.
                    # It chokes up at link time and complains about a duplicate
                    # directory. But this is a good enough workaround.

  if MacOS.prefer_64_bit? && !build.build_32_bit?

     ENV.m64
     ENV.append 'ABI', '64'

     system './configure', *args
     system 'make'
     system 'make -C tune speed'
     system "make am--refresh"
     system './configure', *args
     system 'make'
     system 'make check'
     system 'make install'

     system 'mv', "#{prefix}", "#{Pathname.pwd}/64"
     system 'make distclean'
     
     ENV.delete 'ABI'
  end

   ENV.m32
   ENV.append 'ABI', '32'

   system './configure', *args
   system 'make'
   system 'make -C tune speed'
   system 'make am--refresh'
   system './configure', *args
   system 'make'
   system 'make check'
   system 'make install'

   unless build.build_32_bit? || !MacOS.prefer_64_bit?
   
    system 'lipo',   "-create", "#{prefix}/lib/libgmp.10.dylib",
                                "#{Pathname.pwd}/64/lib/libgmp.10.dylib",
                     "-output", "#{prefix}/lib/libgmp.10.dylib"
    
    system 'lipo',   '-create', "#{prefix}/lib/libgmpxx.4.dylib",
                                "#{Pathname.pwd}/64/lib/libgmpxx.4.dylib",
                     '-output', "#{prefix}/lib/libgmpxx.4.dylib"
                          
    if build.include? 'enable-static'
     system 'lipo',  '-create', "#{prefix}/lib/libgmp.a",
                                "#{Pathname.pwd}/64/lib/libgmp.a",
                     '-output', "#{prefix}/lib/libgmp.a"
    
     system 'lipo',  '-create', "#{prefix}/lib/libgmpxx.a",
                                "#{Pathname.pwd}/64/lib/libgmpxx.a",
                     '-output', "#{prefix}/lib/libgmpxx.a"
    end
   end

   if build.include? 'enable-static'
      system 'strip', '-x',     "#{prefix}/lib/libgmp.a",
                                "#{prefix}/lib/libgmpxx.a"
      system 'lipo', '-info',   "#{prefix}/lib/libgmp.a"
      system 'lipo', '-info',   "#{prefix}/lib/libgmpxx.a"
   end
      system 'strip', '-x',     "#{prefix}/lib/libgmp.10.dylib",
                                "#{prefix}/lib/libgmpxx.4.dylib"
      system 'lipo', '-info',   "#{prefix}/lib/libgmp.10.dylib"
      system 'lipo', '-info',   "#{prefix}/lib/libgmpxx.4.dylib"

 end
end
